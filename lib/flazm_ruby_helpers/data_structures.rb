# frozen_string_literal: true

require 'yaml'
require 'json'

# Adding transversal logic
class ::Array # rubocop:disable Style/ClassAndModuleChildren
  def visit_values(vproc)
    map do |array_item|
      array_item.is_a?(Hash) || array_item.is_a?(Array) ? array_item.visit_values(vproc) : vproc.call(array_item)
    end
  end

  def visit_keys(kproc)
    map do |array_item|
      array_item.is_a?(Hash) || array_item.is_a?(Array) ? array_item.visit_keys(kproc) : array_item
    end
  end

  def to_yaml_inline(pad_left_indents: 0, indent_size: 2)
    indent_string = ' ' * indent_size
    pad_indent = indent_string * pad_left_indents
    result = JSON.parse(to_json).to_yaml(indentation: indent_size, line_width: -1).to_str.lines.to_a[1..-1].collect \
               { |line| pad_indent + line }
    result.join
  end
end

# Ruby hash extensions
class ::Hash # rubocop:disable Style/ClassAndModuleChildren
  def deep_merge(second)
    merger = proc { |_key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 } # rubocop:disable Style/CaseEquality, Metrics/LineLength
    merge(second, &merger)
  end

  def visit_values(vproc)
    map do |key, value|
      value.is_a?(Hash) || value.is_a?(Array) ? { key => value.visit_values(vproc) } : { key => vproc.call(value) }
    end.reduce({}, :merge)
  end

  def visit_keys(kproc)
    map do |key, value|
      if value.is_a?(Hash) || value.is_a?(Array)
        { kproc.call(key) => value.visit_keys(kproc) }
      else
        { kproc.call(key) => value }
      end
    end.reduce({}, :merge)
  end

  def leaf_node?
    map do |_key, value|
      return false if value.is_a?(Hash) || value.is_a?(Array)
    end
    true
  end

  def flatten_paths(path_prefix = '')
    result = {}
    map do |key, value|
      if value.is_a?(Hash)
        result.merge!(value.flatten_paths("#{path_prefix}/#{key}"))
      else
        result.merge!("#{path_prefix}/#{key}" => value)
      end
    end
    result
  end

  def to_yaml_inline(pad_left_indents: 0, indent_size: 2)
    indent_string = ' ' * indent_size
    pad_indent = indent_string * pad_left_indents
    result = JSON.parse(to_json).to_yaml(indentation: indent_size, line_width: -1).to_str.lines.to_a[1..-1].map \
               { |line| pad_indent + line }
    result.join
  end
end
