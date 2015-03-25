require 'delegate'

module Vmdb
  class Sandbox < DelegateClass(Hash)
    def self.create(hash)
      new(hash.blank? ? {} : hash.deep_clone)
    end

    attr_accessor :perf_options, :current_page, :search_text, :detail_sortcol,
      :detail_sortdir, :tree_hosts, :tree_vms

    def initialize(hash)
      @sb             = hash
      @perf_options   = @sb[:perf_options] ? @sb[:perf_options].deep_clone : {}
      @current_page   = @sb[:current_page]
      @search_text    = @sb[:search_text]
      @detail_sortcol = get_detail_sort_col @sb
      @detail_sortdir = get_detail_sort_dir @sb
      @tree_hosts     = @sb[:tree_hosts]
      @tree_vms       = @sb[:tree_vms]
      super
    end

    def [] key
      puts "OMG #{key} : #{caller.first}"
      super
    end

    def active_tree
      @sb[:active_tree]
    end

    def imports
      @sb[:imports] ? @sb[:imports] : nil # Imported file data from 2 stage import
    end

    def to_hash
      copy = @sb.dup
      copy[:perf_options]   = perf_options.deep_clone
      copy[:current_page]   = current_page
      copy[:search_text]    = search_text
      copy[:detail_sortcol] = detail_sortcol
      copy[:detail_sortdir] = detail_sortdir
      copy[:tree_hosts]     = tree_hosts
      copy[:tree_vms]       = tree_vms
      copy
    end

    private

    def get_detail_sort_col(sb)
      sb[:detail_sortcol] == nil ? 0 : sb[:detail_sortcol].to_i   # sort column for detail lists
    end

    def get_detail_sort_dir(sb)
      sb[:detail_sortdir] == nil ? "ASC" : sb[:detail_sortdir]    # sort column for detail lists
    end
  end
end
