Result = ImmutableStruct.new(:status, :data, :message, [:errors]) do
  def success?
    status === :success
  end

  def failure?
    status === :fail
  end

  def data?
    !data.blank?
  end

  def message?
    !message.blank?
  end

  def error
    errors.first
  end
end
