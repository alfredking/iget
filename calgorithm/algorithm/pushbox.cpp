#include <iostream>
#include <vector>
#include <queue>

using std::vector;
using std::queue;
using std::cin;
using std::cout;

int st[100][100][100][100];
int x, y, bx, by, tx, ty;
int m, n;
vector<vector<char>> mm;

bool valid(int x, int y) {
    if (x >= 0 && x < m && y >= 0 && y < n && mm[x][y] != '#')return true;
    return false;
}

int main() {

    cin >> m >> n;
    mm = std::vector<std::vector<char>>(m, vector<char>(n));

    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) {
            char t;
            cin >> t;
            if (t == 'S') {
                x = i;
                y = j;
                // cout <<x<<" "<<y<<endl;
            }
            if (t == '0') {
                bx = i;
                by = j;
            }
            if (t == 'E') {
                tx = i;
                ty = j;
            }
            mm[i][j] = t;
        }

    vector<vector<int>> next = {{-1, 0},{1,  0},{0,  1},{0,  -1}};
    queue<vector<int>> que;
    que.push({x, y, bx, by});

    st[x][y][bx][by] = 1;
    while (!que.empty()) {
        vector<int> t = (vector<int> &&) que.front();
        que.pop();
        x = t[0];
        y = t[1];
        bx = t[2];
        by = t[3];
        for (int i = 0; i < next.size(); i++) {
            int nx = x + next[i][0], ny = y + next[i][1];
            int nnx = nx + next[i][0], nny = ny + next[i][1];
            // 玩家从开始位置走到箱子的位置
            if (valid(nx, ny) && (nx != bx || ny != by) && st[nx][ny][bx][by] == 0) {
                st[nx][ny][bx][by] = st[x][y][bx][by] + 1;
                que.push({nx, ny, bx, by});
                continue;
            }
            // 玩家把箱子推到指定位置
            else if (nx == bx && ny == by && valid(nnx, nny) && st[nx][ny][nnx][nny] == 0) {
                st[nx][ny][nnx][nny] = st[x][y][bx][by] + 1;
                if (mm[nnx][nny] == 'E') {
                    cout << st[nx][ny][nnx][nny] - 1;
                    return 0;
                }
                que.push({nx, ny, nnx, nny});
            }
        }
    }

    cout << -1;
    return 0;
}
