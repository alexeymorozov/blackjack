require 'spec_helper'

module Blackjack
  describe GameCLI do
    let(:printer) { double('printer').as_null_object }
    let(:game_cli) { GameCLI.new(Game.new(MessageSender.new(printer))) }

    describe "#start_round" do
      it "sends a welcome message" do
        expect(printer).to receive(:puts).with('Welcome to Blackjack!')
        game_cli.start_round
      end
    end
  end
end
