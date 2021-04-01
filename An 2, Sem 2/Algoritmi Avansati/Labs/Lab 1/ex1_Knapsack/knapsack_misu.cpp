#include <bits/stdc++.h>

using namespace std;

int main() {
    freopen("knapsack.in", "r", stdin);

    int n, W;
    cin >> n >> W;

    vector<int> values(n), weights(n);
    for (int i = 0; i < n; i++) {
        cin >> weights[i] >> values[i];
    }

    vector<int> dp(W+1, 0);
    vector<int> prev(W+1, -1);
    for (int i = 0; i < n; i++) {
        for (int w = W; w >= 0 and w - weights[i] >= 0; w--) {
            if (dp[w - weights[i]] + values[i] > dp[w]) {
                prev[w] = i;
            }
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }

    cout << dp[W] << "\n";

    while (W > 0) {
        cout << prev[W] << " ";
        W -= weights[prev[W]];
    }
    cout << "\n";

    return 0;
}
