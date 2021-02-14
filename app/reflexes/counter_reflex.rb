class CounterReflex < ApplicationReflex
  def increment
    @count = element.dataset[:count].to_i + element.dataset[:step].to_i
  end

  def select
    row = element.dataset[:row]
    cell = element.dataset[:cell]
    morph "##{element.id}", render(partial: 'home/cell', locals: { row: row, cell: cell, selected: 'selected' })
  end
end
