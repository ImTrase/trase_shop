// zustand "config"

import { create } from 'zustand'

const DEFAULT_CONFIG = {
    MainColor: '#FF1A1A',
    MainColorDarker: '#a30000',
    Locale: {
        "store_title": 'Store',
        "daily_rewards": 'Daily Rewards',
        "information_title": "Information",
        "information_description": "Unlock exclusive perks every day. Enjoy bonuses that enhance your experience, and make each day special with our rewarding system.",
        "day": "Day",
        "vip_only_tooltip": "VIP only, you cannot access this",
        "playtime_shop_title": "Playtime Shop",
        "purchase_button": "Purchase",
        "top_players_title": "Top Players",
        "coins_label": "Coins",
        "selected_title": "REVIEW PURCHASE",
        "back": "Back",
        "contains": "Contains",
        "buy_now": "Buy Now",
        "cannot_buy": "Cannot Afford",
        "escape": "ESC",
        "close": "Close Menu"
    },
}

export const getConfig = create((set) => ({
    Config: DEFAULT_CONFIG,
    setConfig: (Config: any) => set({ Config }),
}))