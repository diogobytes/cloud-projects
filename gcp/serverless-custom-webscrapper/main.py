import requests
from bs4 import BeautifulSoup

def scrape_data():
    url = 'https://www.nba.com/stats'
    response = requests.get(url)
    
    # Use BeautifulSoup to parse the HTML
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Find leaderboard titles and top players
    leaderboard_titles = soup.findAll(class_="LeaderBoardCard_lbcTitle___WI9J")
    player_rows = soup.findAll(class_="LeaderBoardPlayerCard_lbpcTableRow___Lod5")

    # Iterate through titles and players together
    for player_row, leaderboard_title in zip(player_rows, leaderboard_titles):
        player_text = player_row.get_text(strip=True)
        
        # Only process players ranked 1
        if player_text.startswith('1'):  # Checks if the first character is '1'
            # Extract leaderboard title and top player info
            title = leaderboard_title.get_text(strip=True)
            player_info = player_text  # This contains rank, player name, and possibly more info
            
            # Print the leaderboard title and top player info
            print(f"Leaderboard Title: {title} | Top Player Info: {player_info}")

if __name__ == "__main__":
    scrape_data()