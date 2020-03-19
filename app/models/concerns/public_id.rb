# frozen_string_literal: true

require 'hashids'

module PublicId
  def after_create
    self.public_id ||= generate_public_id

    save
  end

  def generate_public_id
    salt = "#{self.class.name}, #{id}"
    salt += 'NaO Eh VoCe QuE EsCoLhE SeR V1D4 L0K4 Eh A V1D4 L0K4 QuE Te EsCoLhE!'
    hash_alphabet = [*'a'..'z', *0..9].join

    Hashids.new(salt, 12, hash_alphabet).encode(id)
  end
end
