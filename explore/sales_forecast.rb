require 'csv'
require 'enumerator'

srand(12)

FREE_THRESHOLD = 0.60
PERSONAL_THRESHOLD = 0.25
PROFESSIONAL_THRESHOLD = 0.10
ENTERPRISE_THRESHOLD = 0.05

thresholds = [FREE_THRESHOLD, PERSONAL_THRESHOLD, PROFESSIONAL_THRESHOLD, ENTERPRISE_THRESHOLD]
subscriptions = []

def free_tier_subs
  rand(0...10)
end

def personal_tier_subs
  rand(0...5)
end

def professional_tier_subs
  rand(0...3)
end

def enterprise_tier_subs
  rand(0...2)
end

12.times.each do |m|
  threshold = rand()

  subscribe_thresholds = [free_tier_subs, personal_tier_subs, professional_tier_subs, enterprise_tier_subs]

  subscribe_thresholds.each_with_index do |month_subs, index|
    if threshold <= thresholds[index]
      subscriptions << month_subs
    else
      subscriptions << 0
    end
  end
end

tiers = ['free','personal','professional','enterprise']
tier_revenues = [-0.10, 36.94, 88.68, 1243.00]

CSV.open('./explore/forecast.csv', 'wb') do |csv|
  csv << ['subscription', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', 'revenue']

  tiers.each_with_index do |tier, index|
    data = []

    subscriptions.each_slice(tiers.length) do |forecasts|
      data << forecasts[index]
    end

    total_subs = data.inject(0,:+)

    data.prepend(tier)
    data.append(total_subs * tier_revenues[index])

    csv << data
  end
end
