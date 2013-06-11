require "spec_helper"

describe Garner::Strategies::Context::Key::RequestGet do
  ["GET", "HEAD"].each do |method|
    context method do

      before(:each) do
        @cache_identity = Garner::Cache::Identity.new
        @request = Rack::Request.new({
          "REQUEST_METHOD" => method,
          "QUERY_STRING" => "foo=bar"
        })

        @mock_context = double "object"
        @mock_context.stub(:request) { @request }
      end

      it_behaves_like "Garner::Strategies::Context::Key strategy"

      it "adds :request_params to the key" do
        subject.apply(@cache_identity, @mock_context)
        @cache_identity.key_hash[:request_params].should == { "foo" => "bar" }
      end

      it "appends to an existing key hash" do
        @cache_identity.key({ :x => :y })
        subject.apply(@cache_identity, @mock_context).key_hash.should == {
          :x => :y,
          :request_params => { "foo" => "bar" }
        }
      end
    end
  end
end