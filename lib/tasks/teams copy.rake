namespace :teams do
  desc 'set points to 0'
  task set_points_to_zero: :environment do
    Team.find_each do |team|
      team.update_column(:points, 0)
    end
  end
end
