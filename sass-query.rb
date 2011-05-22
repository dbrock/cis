require "fileutils"
require "sass"

module SassQuery
  def self.extract(tree, prefixes = [""])
    Visitor.visit(compile(tree), prefixes)
  end

  def self.compile(tree)
    check_nesting tree
    tree = Sass::Tree::Visitors::Perform.visit(tree)
    check_nesting tree
    cssize tree
  end

  def self.check_nesting(tree)
    Sass::Tree::Visitors::CheckNesting.visit(tree)
  end

  def self.cssize(tree)
    tree, extends = Sass::Tree::Visitors::Cssize.visit(tree)
    tree = tree.do_extend(extends) unless extends.empty?
    tree
  end

  class Visitor < Sass::Tree::Visitors::Base
    def self.visit(root, prefixes)
      new(prefixes).send(:visit, root)
    end

    def initialize(prefixes)
      @prefixes = prefixes
    end

    def visit_root(node)
      yield.compact
    end

    def visit_rule(node)
      selector = node.resolved_rules.to_a.join.gsub(/\s+/, " ")
      properties = extract_properties(node)
      [selector, properties] unless properties == {}
    end

    def extract_properties(rule)
      build_hash do |result|
        each_property(rule) do |name, value|
          result[name] = value if interesting? name
        end
      end
    end
  
    def build_hash
      result = {}; yield result; result
    end

    def each_property(rule)
      rule.children.each do |property|
        yield property.resolved_name, property.resolved_value
      end
    end

    def interesting?(name)
      @prefixes.any? { |prefix| name.start_with? prefix }
    end
  end
end
