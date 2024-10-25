import React from 'react'
import { useNavbarStore } from './store'

import { FaCalendarAlt } from "react-icons/fa";
import { FaGift, FaShop } from "react-icons/fa6";

import { useCoinsStore } from '../storage/store';
import { Tooltip } from '@mantine/core'; // Import Tooltip from Mantine

import { getConfig } from '../storage/config';

import styled from 'styled-components'

const Navbar = styled.nav`
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 60px;
    gap: 12px;
    padding-top: 45px;
`

// function to conver # to rgba (opacity is a param I pass)
function hexToRgb(hex: string, opacity: number) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

const NavbarItem = styled.a<{ mainColor: string, darkColor: string; }>`
    color: #FFF;
    text-decoration: none;
    cursor: pointer;
    font-family: 'Meticula', sans-serif;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;

    outline: none;

    min-width: 160px;
    height: 40px;
    flex-shrink: 0;
    padding: 0 12px;

    border-radius: 12px;
    border: 1px solid;
    border-color: rgba(255, 255, 255, 0.42);
    background: linear-gradient(100deg, rgba(177, 177, 177, 0.06) -4.77%, rgba(137, 137, 137, 0.29) 57.33%);

    // Center
    display: flex;
    justify-content: center;
    align-items: center;

    // Select none
    user-select: none;

    &:hover {
        border: 1px solid ${props => hexToRgb(props.darkColor, 0.72)};
        background: ${props => hexToRgb(props.darkColor, 0.56)};
    }
`

const NavbarItemDisabled = styled(NavbarItem)<{ darkColor: string }>`
    opacity: 0.5;
    cursor: not-allowed;
    &:hover {
        border: 1px solid;
        border-color: ${props => hexToRgb(props.darkColor, 0.72)};
        background: ${props => hexToRgb(props.darkColor, 0.56)};
    }
`;


const NavbarItemActive = styled(NavbarItem)<{ mainColor: string }>`
    border: 1px solid ${props => props.mainColor};
    background: ${props => hexToRgb(props.mainColor, 0.56)};
`;

const ButtonIcon = styled.div`
    margin-right: 6px;
    margin-top: 3px;
`

export default function NavbarPage() {
    const { pages, activePage, setActivePage }:any = useNavbarStore()
    const { isVIP }:any = useCoinsStore()

    const { Config }:any = getConfig()
    
    return (
        <Navbar>
            {activePage === 'Store' ? (
                <NavbarItemActive mainColor={Config.MainColor} darkColor={Config.MainColorDarker}>
                    <ButtonIcon><FaShop /></ButtonIcon> {Config.Locale['store_title']}
                </NavbarItemActive>
            ) : (
                <NavbarItem mainColor={Config.MainColor} darkColor={Config.MainColorDarker} onClick={() => setActivePage('Store')}>
                    <ButtonIcon><FaShop /></ButtonIcon> {Config.Locale['store_title']}
                </NavbarItem>
            )}
            {activePage === 'Daily Rewards' ? (
                <NavbarItemActive mainColor={Config.MainColor} darkColor={Config.MainColorDarker}>
                    <ButtonIcon><FaGift /></ButtonIcon> {Config.Locale['daily_rewards']}
                </NavbarItemActive>
            ) : isVIP ? (
                <NavbarItem darkColor={Config.MainColorDarker} mainColor={Config.MainColor} onClick={() => setActivePage('Daily Rewards')}>
                    <ButtonIcon><FaGift /></ButtonIcon> {Config.Locale['daily_rewards']}
                </NavbarItem>
            ) : (
                <Tooltip label="VIP only, you cannot access this" withArrow>
                    <NavbarItemDisabled mainColor={Config.MainColor} darkColor={Config.MainColorDarker}>
                        <ButtonIcon><FaGift /></ButtonIcon> {Config.Locale['daily_rewards']}
                    </NavbarItemDisabled>
                </Tooltip>
            )}
        </Navbar>
    )
}