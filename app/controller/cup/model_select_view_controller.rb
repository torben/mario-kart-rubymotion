class ModelSelectViewController < RPTableViewController
  attr_reader :models

  def viewDidLoad
    super

    @models = [] if models.blank?
    self.tableView.registerClass(ModelSelectTableViewCell, forCellReuseIdentifier:"Cell")

    # close_button = UIBarButtonItem.alloc.initWithTitle("Abbrechen", style: UIBarButtonItemStylePlain, target:self, action:"close_vc")
    # navigationItem.rightBarButtonItem = close_button
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    models.length
  end

  def models=(models)
    @models = models || []

    tableView.reloadData
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    model = models[indexPath.row]
    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)

    case model.class.name
    when "Vehicle"
      cell.text_label.text = model.name
      cell.image_view.load_async_image model.image_url
      cell.text_label.x = 90
      cell.image_view.width = 73
    when "Character"
      cell.text_label.text = model.name
      cell.image_view.load_async_image model.avatar_url
    end

    cell
  end

  def close_vc(model = nil)
    navigationController.popToRootViewControllerAnimated(true)
    navigationController.topViewController.model_selected(model)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:false)

    close_vc(models[indexPath.row])
  end
end