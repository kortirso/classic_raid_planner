class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :time, :slug, :fraction_id

  def date
    object.start_time.strftime('%-d.%-m.%Y')
  end

  def time
    object.start_time.strftime('%H:%M')
  end
end
