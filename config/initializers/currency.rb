class Money
  class Currency
    TABLE.each_value{ |value| value[:priority] = 100 }
    %w(usd eur rub uah byr gbp jpy).each_with_index { |key, index| TABLE[key.to_sym][:priority] = index + 1 }
    SORTED = TABLE.values.sort{ |a, b| a[:priority] <=> b[:priority] }
    # usd eur gbp aud cad jpy byr rub cny uah
  end
end
