from functools import lru_cache

@lru_cache(maxsize=None)
def calc_odds(pos1, score1, pos2, score2):
    if score1 == 20:
        return 27, 0
    total_win1 = 0
    total_win2 = 0
    for dice1 in range(1, 4):
        for dice2 in range(1, 4):
            for dice3 in range(1, 4):
                if not score1 and not score2:
                    print(dice1, dice2, dice3)
                dice = dice1 + dice2 + dice3
                new_pos1 = (pos1 + dice) % 10
                new_score1 = score1 + new_pos1 + 1
                if new_score1 >= 21:
                    total_win1 += 1
                else:
                    w1, w2 = calc_odds(pos2, score2, new_pos1, new_score1)
                    total_win1 += w2
                    total_win2 += w1
    return total_win1, total_win2

win1, win2 = calc_odds(7-1, 0, 5-1, 0)
print(win1, win2)
