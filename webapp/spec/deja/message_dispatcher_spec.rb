require 'spec_helper'
require 'deja/message_dispatcher'

describe Deja::MessageDispatcher do
  let(:message_prefix) {
    "matched_prefix" 
  }

  let(:handler) {
    double(:handler).tap do |handler|
      allow(handler).to receive(:call)
    end
  }

  let(:other_prefix) {
    "other_prefix"  
  }

  let(:other_handler) {
    double(:other_handler).tap do |handler|
      allow(handler).to receive(:call)
    end
  }

  subject(:dispatcher) {
    Deja::MessageDispatcher.new({
      message_prefix => handler,
      other_prefix => other_handler,
    })
  }

  describe "#call" do
    context "when a handler exists with a prefix matching the message" do
      let(:message) { "matched_prefix:1:2:3" }

      it "calls the handler with the message" do
        dispatcher.route(message)
        expect(handler).to have_received(:call).with(message)
      end

      it "does not call handlers which do not match the message" do
        dispatcher.route(message)
        expect(other_handler).not_to have_received(:call)  
      end
    end
    
    context "when no handler exists with a prefix matching the message" do
      let(:message) { "unmatched_prefix:1:2:3" }

      it "does not call handlers which do not match the message" do
        dispatcher.route(message)
        expect(handler).not_to have_received(:call).with(message)
        expect(other_handler).not_to have_received(:call)  
      end
    end
  end
end
