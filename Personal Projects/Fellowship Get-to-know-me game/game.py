from station import *

gameplay = input("Are you ready to play?[yes/no] ")
if gameplay == "Yes" or gameplay == "yes":
    running = 1
else:
    print("Come back when you are ready to play!")
    running = 0
#Start of the game
while running:
    player = input("What is your name? ")   
    #game is running
    row = "~~~~~"*5
    print("\n\n\n"+row+"\n")
    input("Welcome Astronaut %s. Your shuttle has just docked at the Emma Space Station orbiting a star far far away. You are currently in the airlock. Explore the different rooms in the station to learn more about the person the station was named after: Emma Seabrook. If you ever want to exit the game just type in 'exit'. Have fun! \n (Press Enter to continue)" % player)
    stat = startgame()
    while stat.game:
        print("\n\n"+row+"\n")
        print("Welcome to the " + stat.currentLocation.name + ". " + stat.currentLocation.info)
        input("\nPress Enter to continue.")
        print("\n\n"+row+"\n")

        stat.currentLocation.visited = 1
        if stat.currentLocation.items != None:
            stat.currentLocation.viewItems()
        stat.currentLocation.displayoptions()





    response = input("Would you like to play again?[yes/no] ")
    if response == "yes":
        continue
    else:
        running = 0
        break
