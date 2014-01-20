class RPSegmentedControl < UISegmentedControl
  def titleForActiveSegment
    return nil if selectedSegmentIndex.blank?

    titleForSegmentAtIndex selectedSegmentIndex
  end
end