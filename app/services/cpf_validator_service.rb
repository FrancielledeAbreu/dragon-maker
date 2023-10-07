class CpfValidatorService
  def self.valid?(cpf)
    cpf = cpf.to_s.tr('^0-9', '')

    return false if cpf.length != 11 || cpf.scan(/^(.{1})\1+$/).any?

    first_digit = calculate_digit(cpf, 9, 10)
    second_digit = calculate_digit(cpf, 10, 11)

    cpf[-2, 2] == "#{first_digit}#{second_digit}"
  end

  def self.calculate_digit(cpf, length, weight)
    sum = 0

    length.times do |index|
      sum += cpf[index].to_i * (weight - index)
    end

    mod = sum % 11
    mod < 2 ? 0 : 11 - mod
  end
end
