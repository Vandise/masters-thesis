require 'csv'
require 'enumerator'

srand(12)

#CPM
LN_CPM = 20000 # 131.8, 0.39 click rate, 6.59/1k impressions

# 2%
GG_CPM = 42000 # 118 , 2% click rate, 2.80/1000 impressions

VISITORS = (LN_CPM*0.0039 + GG_CPM*0.02)
CONVERSION_RATE = 0.01
CUSTOMERS = (VISITORS * CONVERSION_RATE).floor()

FREE_THRESHOLD = 0.85
PERSONAL_THRESHOLD = 0.95
PROFESSIONAL_THRESHOLD = 0.98
ENTERPRISE_THRESHOLD = 0.98

thresholds = [
  Proc.new { |t| t <= FREE_THRESHOLD },
  Proc.new { |t| t > FREE_THRESHOLD && t <= PERSONAL_THRESHOLD},
  Proc.new { |t| t > PROFESSIONAL_THRESHOLD && t <= ENTERPRISE_THRESHOLD},
  Proc.new { |t| t > ENTERPRISE_THRESHOLD} 
]

subscriptions = []

12.times.each do |m|
  sub_model_amts = [0,0,0,0]

  (1...CUSTOMERS).each do
    threshold_rand = rand()
    thresholds.each_with_index do |threshold_proc, index|
      if threshold_proc.call(threshold_rand)
        sub_model_amts[index] += 1
      end
    end
  end

  sub_model_amts.each do |subs|
    subscriptions << subs
  end
end

tiers = ['free','personal','professional','enterprise']
tier_revenues = [-0.10, 36.94, 88.68, 1243.00]

CSV.open('./explore/forecast.csv', 'wb') do |csv|
  csv << ['subscription', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', 'total revenue']

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
