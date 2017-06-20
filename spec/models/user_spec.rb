# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:check_records) }

  subject { create(:user) }

  describe '#checkin' do
    it 'no check_record' do
      expect { subject.checkin }.to change { CheckRecord.count }.by(1)
    end

    it 'has check_record exclude -INFINITY..specific.ago' do
      subject.checkin
      expect { subject.checkin }.to change { CheckRecord.count }.by(0)
    end
  end

  describe 'find_type' do

    # it 'all case' do
    #   subject.checkin
    #   expect(subject.find_type).to eq(1)

    #   Timecop.travel(5.minutes)
    #   subject.checkin
    #   expect(subject.find_type).to eq(1)

    #   Timecop.travel(5.minutes)
    #   subject.checkin
    #   expect(subject.find_type).to eq(0)

    #   Timecop.travel(1.days)
    #   subject.checkin
    #   expect(subject.find_type).to eq(0)
    # end

    it 'first times' do # 0 -> 1
      subject.checkin
      expect(subject.find_type).to eq(1)
    end

    it 'second times' do # 0,1 -> 1
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      expect(subject.find_type).to eq(1)
    end

    it 'third times' do # 0,1,0 -> 0
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      expect(subject.find_type).to eq(0)
    end

    it 'next day' do
      subject.checkin
      Timecop.travel(1.days)
      subject.checkin
      expect(subject.find_type).to eq(0)
    end
  end

  describe 'check_records' do
    it 'clockin_1' do
      subject.checkin
      expect(subject.check_records.last.type).to eq(0)
    end

    it 'clockout' do
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      expect(subject.check_records.last.type).to eq(1)
    end

    it 'clockin_2' do
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      expect(subject.check_records.last.type).to eq(0)
    end

    it 'clockout_2' do
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      expect(subject.check_records.last.type).to eq(1)
    end

    it 'next day clockin' do
      subject.checkin
      Timecop.travel(1.days)
      subject.checkin
      expect(subject.check_records.last.type).to eq(0)
    end

    it 'next day clockout' do
      subject.checkin
      Timecop.travel(1.days)
      subject.checkin
      Timecop.travel(5.minutes)
      subject.checkin
      expect(subject.check_records.last.type).to eq(1)
    end
  end
end















