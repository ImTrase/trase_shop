import { create } from 'zustand'

export const useNavbarStore = create((set) => ({
  pages: ['Store', 'Daily Rewards'],
  activePage: 'Store',
  setActivePage: (page: string) => set({ activePage: page }),
}))

