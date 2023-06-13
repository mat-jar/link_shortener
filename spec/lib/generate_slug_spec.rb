require 'rails_helper'

describe GenerateSlug do

      describe "Call service" do

      it "generates a slug" do
        expect(described_class.call).to match /\A[a-z]+(?:-[a-z]+)*\z/i
      end
  end
end
