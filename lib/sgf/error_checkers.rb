class SGF::StrictErrorChecker
  def check_for_errors_before_parsing string
    unless string[/\A\s*\(\s*;/]
      msg = "The first two non-whitespace characters of the string should be (;"
      msg << " but they were #{string[0..1]} instead."
      raise(SGF::MalformedDataError, msg)
    end
  end
end

class SGF::LaxErrorChecker
  def check_for_errors_before_parsing string
    # just look the other way
  end
end
