#include <iostream>
#include <vector>
#include <queue>
#include <cmath>
#include <climits>
#include <algorithm>

using namespace std;

struct Node {
    int x, y;
    int g_cost;
    int h_cost;
    Node* parent;

    Node(int x, int y, int g_cost, int h_cost, Node* parent) : x(x), y(y), g_cost(g_cost), h_cost(h_cost), parent(parent) {}

    bool operator<(const Node& other) const {
        return (g_cost + h_cost) > (other.g_cost + other.h_cost);
    }
};

vector<pair<int, int>> reconstructPath(Node* current) {
    vector<pair<int, int>> path;
    while (current != nullptr) {
        path.push_back(make_pair(current->x, current->y));
        current = current->parent;
    }
    reverse(path.begin(), path.end());
    return path;
}

vector<pair<int, int>> astar(const vector<vector<int>>& grid, int start_x, int start_y, int goal_x, int goal_y) {
    int rows = grid.size();
    int cols = grid[0].size();

    vector<vector<int>> g_cost(rows, vector<int>(cols, INT_MAX));
    vector<vector<int>> h_cost(rows, vector<int>(cols, 0));
    vector<vector<Node*>> parents(rows, vector<Node*>(cols, nullptr));

    priority_queue<Node*> openSet;

    Node* startNode = new Node(start_x, start_y, 0, 0, nullptr);
    g_cost[start_x][start_y] = 0;
    openSet.push(startNode);

    while (!openSet.empty()) {
        Node* current = openSet.top();
        openSet.pop();

        if (current->x == goal_x && current->y == goal_y) {
            return reconstructPath(current);
        }

        vector<pair<int, int>> neighbors = {
            {current->x - 1, current->y},  // Left
            {current->x + 1, current->y},  // Right
            {current->x, current->y - 1},  // Up
            {current->x, current->y + 1}   // Down
        };

        for (const auto& neighbor : neighbors) {
            int neighbor_x = neighbor.first;
            int neighbor_y = neighbor.second;

            if (neighbor_x >= 0 && neighbor_x < rows && neighbor_y >= 0 && neighbor_y < cols && grid[neighbor_x][neighbor_y] == 0) {
                int new_g_cost = current->g_cost + 1;
                int new_h_cost = abs(neighbor_x - goal_x) + abs(neighbor_y - goal_y);

                if (new_g_cost < g_cost[neighbor_x][neighbor_y]) {
                    g_cost[neighbor_x][neighbor_y] = new_g_cost;
                    h_cost[neighbor_x][neighbor_y] = new_h_cost;
                    parents[neighbor_x][neighbor_y] = current;

                    Node* neighborNode = new Node(neighbor_x, neighbor_y, new_g_cost, new_h_cost, current);
                    openSet.push(neighborNode);
                }
            }
        }
    }

    return {};  // No path found
}

int main() {
    vector<vector<int>> grid = {
        {0, 1, 0, 0, 0},
        {0, 1, 0, 1, 0},
        {0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0}
    };

    int start_x = 0;
    int start_y = 0;
    int goal_x = 4;
    int goal_y = 4;

    vector<pair<int, int>> path = astar(grid, start_x, start_y, goal_x, goal_y);

    if (path.empty()) {
        cout << "No path found." << endl;
    } else {
        cout << "Shortest path: ";
        for (const auto& point : path) {
            cout << "(" << point.first << ", " << point.second << ") ";
        }
        cout << endl;
    }

    return 0;
}
