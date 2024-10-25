import { create } from 'zustand'
import { useNuiEvent } from '../../hooks/useNuiEvent'

// Store the daily rewards items []
export const useDailyRewardsStore = create((set) => ({
    dailyRewards: [],
    setDailyRewards: (dailyRewards: any) => set({ dailyRewards }),
}))

const EXAMPLE_PRODUCT = {
    label: 'Example Product',
    price: 100,
    features: ['Feature 1', 'Feature 2', 'Feature 3'],
    index: 1,
    image: 'https://cdn.discordapp.com/attachments/1119540289196003410/1238234576292282508/image.png?ex=663e8b50&is=663d39d0&hm=2007a293df4c97bc04b5195d414f9e1696b7a203173f3bffb7d512de593e760c&',
}

// Selected Product
export const useSelectedProductStore = create((set) => ({
    selectedProduct: null,
    setSelectedProduct: (selectedProduct: any) => set({ selectedProduct }),
}))

// Categories
export const useCategoriesStore = create((set) => ({
    categories: ['Weapons'],
    activeCategory: 'Weapons',
    setActiveCategory: (category: string) => set({ activeCategory: category }),
    setCategories: (categories: string[]) => set({ categories }),
}))

// Coins
export const useCoinsStore = create((set) => ({
    coins: 0,
    isVIP: false,
    setCoins: (coins: number) => set({ coins }),
    setIsVIP: (isVIP: boolean) => set({ isVIP }),
}))

// Top Players
export const useTopPlayersStore = create((set) => ({
    topPlayers: [],
    setTopPlayers: (topPlayers: any) => set({ topPlayers }),
}))