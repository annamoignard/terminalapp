require_relative 'mood_tracker_helper'

class Menu
  include MoodTracker # this allows us to use all methods, even non self methods from the module
  def initialize(user)
    @user = user
    @quotes = Quotes.new
    @moods = read_moods
  end
# Main meny selection - user can access all features of the application 
  def menu_selection
    PROMPT.select('Please make a selection!'.colorize(:magenta)) do |menu|
      menu.choice({ name: "Track Today's Mood", value: '1' })
      menu.choice({ name: 'View Tracked Moods', value: '2' })
      menu.choice({ name: 'Good Vibes Please', value: '3' })
      menu.choice({ name: 'Exit', value: '4' })
    end
  end
# when called, will display tracked moods in a table format 
  def terminal_table
    rows = @moods.map do |mood|
      mood.to_arr
    end
    table = Terminal::Table.new({ headings: HEADINGS, rows: rows })
    puts table
  end

  def router
    loop do
      case menu_selection
      when '1'
        tracker = Track.todays_mood(@user)
        @moods << tracker
      when '2'
        puts 'Your tracked moods:'.colorize(:blue)
        terminal_table
      when '3'
        @quotes.good_vibes
      when '4'
        puts "Bye-bye! Have a great day #{@user.username}!".colorize(:cyan)
        write_moods(@moods)
        exit
      end
    end
  end
end
