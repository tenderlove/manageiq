require "spec_helper"

describe Vmdb::Sandbox do
  context 'backwards compat' do
    it 'calls methods for keys that should be methods' do
      sb = Vmdb::Sandbox.new(:search_text => 'foo')
      expect(sb.search_text).to eq('foo')

      sb.search_text = 'bar'
      expect(sb[:search_text]).to eq('bar')
    end
  end

  context 'initialized with existing session hash' do
    it 'knows active_tree' do
      sb = Vmdb::Sandbox.new(:active_tree => 'foo')
      expect(sb.active_tree).to eq('foo')
    end

    it 'knows current_page' do
      sb = Vmdb::Sandbox.new(:current_page => 'foo')
      expect(sb.current_page).to eq('foo')
    end

    it 'knows search_text' do
      sb = Vmdb::Sandbox.new(:search_text => 'foo')
      expect(sb.search_text).to eq('foo')
    end

    it 'returns 0 for unset detail_sortcol' do
      sb = Vmdb::Sandbox.new({})
      expect(sb.detail_sortcol).to eq(0)
    end

    it 'returns detail_sortcol' do
      sb = Vmdb::Sandbox.new(:detail_sortcol => 10)
      expect(sb.detail_sortcol).to eq(10)
    end

    it 'to_is detail_sortcol' do
      sb = Vmdb::Sandbox.new(:detail_sortcol => "10")
      expect(sb.detail_sortcol).to eq(10)
    end

    it 'returns ASC for unset detail_sortdir' do
      sb = Vmdb::Sandbox.new({})
      expect(sb.detail_sortdir).to eq('ASC')
    end

    it 'returns detail_sortdir' do
      sb = Vmdb::Sandbox.new(:detail_sortdir => 'foo')
      expect(sb.detail_sortdir).to eq('foo')
    end

    context 'perf options' do
      it 'defaults to an empty hash' do
        sb = Vmdb::Sandbox.new({})
        expect(sb.perf_options).to eq({})
      end

      it 'returns deep clones existing' do
        po = {}
        sb = Vmdb::Sandbox.new(:perf_options => po)
        expect(sb.perf_options.object_id).to_not eq(po.object_id)
      end

      it 'always returns the same object' do
        sb = Vmdb::Sandbox.new(:perf_options => {})
        expect(sb.perf_options.object_id).to eq(sb.perf_options.object_id)
      end
    end

    context 'to_hash' do
      it 'puts updated options in the to_hash' do
        sb = Vmdb::Sandbox.new(:perf_options => {})
        sb.perf_options = { :foo => :bar }
        expect(sb.to_hash[:perf_options][:foo]).to eq(:bar)
      end

      it 'puts updated current_page in to_hash' do
        sb = Vmdb::Sandbox.new(:current_page => 'foo')
        sb.current_page = 'bar'
        expect(sb.to_hash[:current_page]).to eq('bar')
      end

      it 'puts updated search_text in to_hash' do
        sb = Vmdb::Sandbox.new(:search_text => 'foo')
        sb.search_text = 'bar'
        expect(sb.to_hash[:search_text]).to eq('bar')
      end

      it 'puts updated detail_sortcol in to_hash' do
        sb = Vmdb::Sandbox.new(:detail_sortcol => 'foo')
        sb.detail_sortcol = 'bar'
        expect(sb.to_hash[:detail_sortcol]).to eq('bar')
      end

      it 'puts updated detail_sortdir in to_hash' do
        sb = Vmdb::Sandbox.new(:detail_sortdir => 'foo')
        sb.detail_sortdir = 'bar'
        expect(sb.to_hash[:detail_sortdir]).to eq('bar')
      end

      it 'puts updated tree_hosts in to_hash' do
        sb = Vmdb::Sandbox.new(:tree_hosts => 'foo')
        sb.tree_hosts = 'bar'
        expect(sb.to_hash[:tree_hosts]).to eq('bar')
      end

      it 'puts updated tree_vms in to_hash' do
        sb = Vmdb::Sandbox.new(:tree_vms => 'foo')
        sb.tree_vms = 'bar'
        expect(sb.to_hash[:tree_vms]).to eq('bar')
      end
    end

    it 'knows imports' do
      sb = Vmdb::Sandbox.new(:imports => 'foo')
      expect(sb.imports).to eq('foo')
    end

    it 'knows tree_vms' do
      sb = Vmdb::Sandbox.new(:tree_vms => 'foo')
      expect(sb.tree_vms).to eq('foo')
    end

    it 'knows tree_hosts' do
      sb = Vmdb::Sandbox.new(:tree_hosts => 'foo')
      expect(sb.tree_hosts).to eq('foo')
    end

    # FIXME: is this really necessary? It's what the code does today
    it 'imports return nil for false' do
      sb = Vmdb::Sandbox.new(:imports => false)
      expect(sb.imports).to eq(nil)
    end

    context 'reset' do
      %i( current_page search_text detail_sortcol detail_sortdir tree_hosts
          tree_vms ).each do |key|
        it "nils out #{key}" do
          sb = Vmdb::Sandbox.new(key => 'foo')
          sb.reset!
          expect(sb.send(key)).to be_nil
        end

        it "removes #{key} from to_hash" do
          sb = Vmdb::Sandbox.new(key => 'foo')
          sb.reset!
          expect(sb.to_hash.key?(key)).to be(false)
        end
      end

      it 'nils out perf_options' do
        sb = Vmdb::Sandbox.new(:perf_options => {})
        sb.reset!
        expect(sb.perf_options).to be_nil
      end

      it 'removes perf_options from to_hash' do
        sb = Vmdb::Sandbox.new(:perf_options => {})
        sb.reset!
        expect(sb.to_hash.key?(:perf_options)).to be(false)
      end
    end
  end
end
