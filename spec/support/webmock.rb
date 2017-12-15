RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, %r(/finestmedia.ee\/kwh/))
      .with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: 'stubbed request', headers: {})
  end
end
