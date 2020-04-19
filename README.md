# celo-test

Answers

1. What is your favourite design pattern, and why?

  I'm most familiar with MVC and MVVM. I like MVVM out of the two, they produce smaller VCs, make testing easier, and implementation isn't complex

2. For your favourite programming language, tell me about a new (or upcoming) language feature that has you excited. Why is it exciting for you?
  
  Swift would be my choice of weapon. It's super readable and flexible. Swift is also in rapid dev so it's pretty to keep up with the new features but I quite like the new changes to the way we can use structs.

3. What do you not like to see when you're reviewing your own of another colleague's code?

 While reviewing, I look out for:

 - Code structure and readability (as long as it follows our agreed upon coding style, I'm good)

 - Abstraction of complex business logic so no super long methods and tests for them

 - Any obvious crashes that they may have missed. For example, unwrapping optionals without checking

4. Tell me about a time you fixed a performance issue.

  Couple weeks ago I found a pretty big memory leak in our app. We have button that globally lives on the nav bar of the app and allows users to switch between tableviews, the issue here was, when a user switches to a different view the button wouldn't lose the reference to the old tableview and while refreshing the new view it refreshing all other tableviews user visited prior. This could eventually crash the app and increase server load as it could be making 20 - 200 (or more) request at once.

  I used the memory graph to confirm and debug the problem. This occurred because of the way we used the Associated Object to retain a global reference (which was never removed).
