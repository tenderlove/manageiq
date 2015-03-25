require "spec_helper"

describe HostController do
  context "#button" do
    render_views

    before(:each) do
      set_user_privileges
      FactoryGirl.create(:vmdb_database)
      EvmSpecHelper.create_guid_miq_server_zone
    end

    it "doesn't break" do
      h1 = FactoryGirl.create(:host)
      h2 = FactoryGirl.create(:host)
      session[:host_items] = [h1.id, h2.id]
      session[:settings] = {:views     => {:host => 'grid'},
                            :display   => {:quad_truncate => 'f'},
                            :quadicons => {:host => 'foo'}}
      get :edit
      expect(response.status).to eq(200)
    end

    it "when VM Right Size Recommendations is pressed" do
      controller.should_receive(:vm_right_size)
      post :button, :pressed => 'vm_right_size', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when VM Migrate is pressed" do
      controller.should_receive(:prov_redirect).with("migrate")
      post :button, :pressed => 'vm_migrate', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when VM Retire is pressed" do
      controller.should_receive(:retirevms).once
      post :button, :pressed => 'vm_retire', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when VM Manage Policies is pressed" do
      controller.should_receive(:assign_policies).with(VmOrTemplate)
      post :button, :pressed => 'vm_protect', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when MiqTemplate Manage Policies is pressed" do
      controller.should_receive(:assign_policies).with(VmOrTemplate)
      post :button, :pressed => 'miq_template_protect', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when VM Tag is pressed" do
      controller.should_receive(:tag).with(VmOrTemplate)
      post :button, :pressed => 'vm_tag', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when MiqTemplate Tag is pressed" do
      controller.should_receive(:tag).with(VmOrTemplate)
      post :button, :pressed => 'miq_template_tag', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end

    it "when Custom Button is pressed" do
      host = FactoryGirl.create(:host)
      custom_button = FactoryGirl.create(:custom_button, :applies_to_class => "Host")
      d = FactoryGirl.create(:dialog, :label => "Some Label")
      dt = FactoryGirl.create(:dialog_tab, :label => "Some Tab")
      d.add_resource(dt, {:order => 0})
      ra = FactoryGirl.create(:resource_action, :dialog_id => d.id)
      custom_button.resource_action = ra
      custom_button.save
      user = FactoryGirl.create(:user, :userid => 'wilma')
      session[:userid] = "wilma"
      post :button, :pressed => "custom_button", :id => host.id, :button_id => custom_button.id
      expect(response.status).to eq(200)
      controller.send(:flash_errors?).should_not be_true
    end

    it "when Drift button is pressed" do
      controller.should_receive(:drift_analysis)
      post :button, :pressed => 'common_drift', :format => :js
      controller.send(:flash_errors?).should_not be_true
    end
  end
end
