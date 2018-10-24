namespace :trainer do
  desc 'Train'
  task do: :environment do
    Trainer.do
  end
end
