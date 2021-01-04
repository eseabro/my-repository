class Station:
    currentLocation = None
    ended = 0
    game = 1
    allLocations = []
    endgame = None


class Location:
    visited = 0
    def __init__(self, name, info, station,items):
        self.name = name
        self.info = info
        self.station = station
        self.items = items


    def displayinfo(self):
        print(self.info)
    
    def displayoptions(self):
        options = 1
        while options:
            self.remainder()
            if self.station.currentLocation.name == "End Game":
                self.station.game = 0
                print("This is the end of the game. You have visited all of the locations! Thank you for getting to know me :)")
                break
            print("Type 'left' to visit: " + self.left.name + " and type 'right' to visit " + self.right.name)
            choice = input(" ")
            if choice == "left":
                self.left.back = self
                self.station.currentLocation = self.left
                options = 0

            elif choice =="right":
                self.right.back = self
                self.station.currentLocation = self.right
                options = 0
            elif choice == "exit":
                self.station.game = 0
                break
            else:
                print("Please select a valid choice")
    
    def remainder(self):
        count = 0
        for loc in range(0, len(self.station.allLocations)):
            if self.station.allLocations[loc].visited == 0:
                if count == 0:
                    self.left = self.station.allLocations[loc]
                    count += 1
                    if count == 1 and loc >= (len(self.station.allLocations)-2):
                        self.right = self.left
                elif count == 1:
                    self.right = self.station.allLocations[loc]
                    return

            elif count == 0 and loc > (len(self.station.allLocations)-2):
                self.station.game = 0
                self.station.currentLocation = self.station.endgame
                return

    def viewItems(self):

        while True:
            print("Here are some items you can view: ")
            options_left = len(self.items)
            for item in self.items:

                if item.viewed == 0:
                    print(item.name)
                else:
                    options_left -=1

                    if options_left == 0:
                        print("\n\nYou have viewed all of the items.\n - - - - - - - - - - - - - - - - - - - -\n\n\n")
                        return

                    result = ''
                    for c in item.name:
                        result = result + '\u0336' + c
                    print(result)

            ch_it = input("Which item would you like to view? (type in the name of the item you would like to view. List items are case-sensitive. Already visited items will be displayed with a strikethrough, however, they can still be visited more than once.) ")
            count = 1
            for options in self.items:
                if ch_it == options.name:
                    # view items
                    options.viewed = 1
                    print("\n\n" + options.paragraph)
                    input("Press enter to continue \n\n")
                else:
                    if count < len(self.items):
                        count +=1

                    else:
                        print("\n\nPlease select one of the items listed.\n Be careful, items are case-sensitive.")
        print("You have viewed all of the items. \n\n")


                
            
    # def setlrb(self, left, right, back):
    #     self.left = left
    #     self.right = right
    #     self.back = back

class item:
    viewed = 0
    def __init__(self, name, para):
        self.name = name
        self.paragraph = para


def startgame():
    stat = Station()

    info_a = "Here at the airlock, you can learn more about Emma's early life. Emma was born in the United States, making her a US citizen. She lived in Paris, France, and then Toronto, Canada. She has two sisters, one older and one younger. Because of this, she learned to problem-solve and collaborate with others from an early age."
    airlock = Location('Airlock', info_a, stat, None)

    info_l = "Here in the Laboratory, you can learn more about Emma's passion for aerospace. Growing up, she loved watching the stars and planes flying overhead. She quickly joined the Royal Astronomical Society of Canada where she was a member for seven years. During this time, she learned a lot and her passion grew. When she was in highschool, she visited the University of Toronto Aerospace Showcase and after speaking to the students and seeing the designs they came up with, she decided that she wanted to be an aerospace engineer."
    Laboratory = Location('Laboratory', info_l, stat, None)

    info_q = "Here in the Crew Quarters, you can learn more about Emma's personal interests and leisure. Around the room there are various items that you can look at to learn more about her different interests."

    chess = item("Chess Set", "Emma loves puzzle games like chess. She also loves sudoku and jigsaw puzzles.")
    sports = item("Trophy", "Emma loves to play sports. She played baseball for eight years, soccer for seven badminton for four, and volleyball for four. She also ran the cross country race eight years in a row.")
    baking = item("Cookies", "In her free time, Emma loves to bake and cook. She loves to try new dishes and bake new things. Recently she made french macarons, croissants and homemade pizza all from scratch.")
    music = item("Guitar", "Emma loves music in many forms. She got her first guitar at the age of five and over the years taught herself to play. She also learned how to play the piano and drums. She loves to listen to different genres and go to concerts.")
    cq_it = [chess, sports, music, baking]
    Crewq = Location('Crew Quarters', info_q, stat, cq_it)
    
    Old = item("Old message", "Throughout her life, Emma was a Girl Guide. She loved the program so much that she later became a junior leader which means that she got to lead her own girl guide group. At her highschool, she was the Public Relations director of her school's student government. She was also the president of her school's Eco Club for a year. She was a member of her highschool's STEM team that won $20,000 worth of technology for the school in the Samsung Solve for Tomorrow contest.")
    New = item("Today's message", "Emma is currently a member of the University of Toronto Aerospace team. She is currently working on a project that will simulate the flight of liquid rockets. She is also a member of the University of Toronto chapter of Engineers without borders where she will be working with the Local Poverty Alleviation portfolio.")
    co_it = [Old, New]
    info_c = "Here in the Communications Room, you can learn more about the teams and projects Emma has worked on."
    Communications = Location('Communications Room', info_c, stat, co_it)

    info_e = "Here in the Equipment Room, you can learn more about Emma's past work experience. Throughout highschool, Emma worked as a swim instructor at the Thornlea Pool in Markham, ON, Canada. This means that she had to be first-aid trained and had to be a certified bronze-cross level swimmer. In the summer of 2021, she worked in the Multimedia Labratory at the University of Toronto where she helped build a web platform to facilitate data collection for the ADP project. Throughout the summer, she also worked as a website designer for the Covid Action Hub. The Covid Action Hub is a student initiative that created a platform to connect student initiatives tackling COVID-19 with student volunteers."
    Equipment = Location('Equipment Room', info_e, stat, None)
        
    info_n = "Here in the Navigation Room, you can learn more about her university program: Engineering Science. The Engineering Science program at the University of Toronto is one of the most competitive and rigorous engineering programs in Canada. Students spend their first two years taking general engineering courses. After their second year, they can choose to specialize into one of the many Engineering Science majors. Emma will be specializing in the aerospace major. "
    Navigation = Location('Navigation Room', info_n, stat, None)




    end_info = "This is the end of the game. You have visited all of the locations! Thank you for getting to know me :)"
    endofgame = Location('End Game', end_info, stat, None)


    # airlock.setlrb(Laboratory, Crewq, None)
    # Laboratory.setlrb(Navigation, Equipment, airlock)
    # Crewq.setlrb(Equipment, Engine, Crewq)
    # Navigation.setlrb(Communications, Navigation.remainder(), Laboratory)
    # Equipment.setlrb(Communications, Kitchen, None)
    # Engine.setlrb(Kitchen, Engine.remainder(), Crewq)
    # Communications.setlrb(Communications.remainder(), Communications.remainder(), None)
    # Kitchen.setlrb(Kitchen.remainder(), Kitchen.remainder(), None)





    allLocations = [airlock, Laboratory, Crewq, Communications, Equipment, Navigation]
    stat.currentLocation = airlock
    stat.endgame = endofgame
    stat.allLocations = allLocations
    return stat
