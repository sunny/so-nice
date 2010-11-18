class LoadError
  def retried?
    @retried
  end
  def retry
    @retried = true
    super
  end
end