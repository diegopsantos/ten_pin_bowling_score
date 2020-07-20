# Ten-pin Bowling Score

This is a command-line application to score a game of ten-pin bowling (https://en.wikipedia.org/wiki/Ten-pin_bowling#Rules_of_play).




##  How to Run
After running: `bundle` on the project's root we can execute the application	:

 - There are three text files for three test cases: Perfect Game, Normal Game with two players and Zero Game
	 1. spec/fixtures/files/game_example.txt
	 2. spec/fixtures/files/perfect_game_example.txt
	 3. spec/fixtures/files/zero_game_example.txt
	 
	
 - You can run any of them  through the following command:

     `ruby -r "./lib/game.rb" -e "Game.new('./spec/fixtures/files/FILE_NAME').show_game_score"`

	
