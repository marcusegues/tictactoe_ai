# tictactoe_ai

Run `ruby game.rb` on the command line to play the game. 

Note: Though the AI behaves correctly (never loses), there is one further improvement to make:

- when the user makes a mistake, the AI chooses the first move it encounters that will lead to a sure victory for the AI. However, his move may not lead to the victory in the shortest number of moves, leading the AI to sometimes not choose an obvious immediate victory and instead go for a victory two moves ahead.
- this can be solved by augmenting the tree structure with heights for the nodes, and then testing for the shortest path to victory.

- Allows user to choose if he wants to make the first move or not.
- A tree is generated after the first move is made with all possible states of the game.
- Each node stores instance variables for the current history of moves made by each player. This current history is simply an integer, where the nine least significant bits represent positions on the tic tac toe board. A one means that position has been played, a zero means it hasn't
- Each node contains a @color instance variable, representing the current player. Can be either :white or :black.
- To determine the list of possible next_moves at each node, I take the complement of the bitwise OR operation performed between the two current histories of play (which are nine-bit sequences).
- Each node contains a list of adjacent nodes, where adjacent means they represent possible game states one move forward.
- Each node contains an instance variable @paths_to_victory, a boolean. This is true if 1) the game state at this node is one of victory or 2) if there is at least one node with @paths_to_victory true in the nodes two levels down (the nodes adjacent to the nodes adjacent to this node). The latter case basically means that if the game is not won at the current state, there is at least one possible choice next time the current player plays that represents a path to victory. 
- A node with path_to_victory true means that from this state onwards there is no way to stop this player from winning if this player makes the right moves (follows the subsequent nodes with @path_to_victory true)
- The AI works by making two checks: 1) are there any moves (nodes in the next state of the game) that contain @path_to_victory true? If so, this they represent sure paths to victory for the AI. It will choose the first of these that it encounters. This only happens if the user has made a mistake in his plays. 2) for each possible current move of the AI, do not choose the move if any of the immediately following moves (made by the user player) has @path_to_victory true. Choosing one of these moves would constitute a mistake that would give the user the possibility of a sure win.
