class Host < Sequel::Model(:hosts)
  unrestrict_primary_key
  plugin :serialization
  serialize_attributes :pg_array, :packages

  def as_json
    { name: name, packages: packages }
  end
end
