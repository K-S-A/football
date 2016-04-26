RSpec.shared_context 'for logged-in user' do
  render_views

  before(:all) do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end

  let!(:log_in) { sign_in @admin }
  let(:log_out) { sign_out @admin }
  let(:error) { 'You need to sign in or sign up before continuing.' }
end

RSpec.shared_examples 'for successfull request' do |format|
  format ||= 'application/json'

  it "responds with #{format} format" do
    expect(response.content_type).to eq(format)
  end

  it 'responds with success status' do
    expect(response).to have_http_status(:success)
  end
end

RSpec.shared_examples 'for assigning instance variable' do |inst_var|
  let(:inst_var_value) { instance_variable_get("@#{inst_var}") }

  it "assigns @#{inst_var}" do
    expect(assigns(inst_var)).to eq(inst_var_value)
  end
end

RSpec.shared_examples 'for rendering templates' do |names|
  names.each do |name|
    it "renders the '#{name}' template" do
      expect(response).to render_template(name)
    end
  end
end

RSpec.shared_examples 'for responding with json' do |obj, res|
  it "responds with #{obj} of #{res} attributes" do
    expect(response.body).to eq(result)
  end
end

RSpec.shared_examples 'for render nothing with status' do |code|
  it "responds with #{code} status" do
    expect(response.status).to eq(code)
  end

  it 'renders nothing' do
    expect(response).to render_template(nil)
  end
end

RSpec.shared_examples 'for failed update of' do |obj|
  it "fails to update #{obj}" do
    expect(assigns(obj)).to eq(instance_variable_get("@#{obj}"))
  end
end
