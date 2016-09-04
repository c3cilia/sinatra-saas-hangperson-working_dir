Feature: Cheating should not be possible
  To prevent cheating I should be on the lookout before the game starts and while the game is in progress
	
Scenario: If haven't started a game 
	And I try to go to the URL "/win"
	Then I should be on the new page

Scenario: I am in the middle of a game
	Given I start a new game with word "cheating"
	And I try to go to the URL "/win"
	Then I should be on the show page
	And I should see "Sorry!! don't navigate manually"

#Background: I am in the middle of a game
#  Given I start a new game with word "cheat"

#Scenario: game not over if i visit the /win manually
#  When I try to go to the URL "/win"
#  Then I should be on the show page
#  And I should see "Sorry!! don't navigate manually"