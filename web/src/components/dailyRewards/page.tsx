import React, { useState } from "react";
import styled from "styled-components";

import { Card } from '@mantine/core';
import Stripes from './stripes.png';
import CheckMark from './claimed.png';
import { GiCheckMark } from "react-icons/gi";
import { IoMdLock } from "react-icons/io";


import { fetchNui } from "../../utils/fetchNui";

import { useDailyRewardsStore } from "../storage/store";
import { useTrail, animated } from 'react-spring'; // Import react-spring for animations
import { getConfig } from '../storage/config';

function hexToRgb(hex: string, opacity: number) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

const StyledCard = styled(Card)<{ mainColor: string, canOpen: boolean }>`
    background-color: rgba(2, 2, 6, 0.56) !important;
    border-radius: 12px !important;
    display: flex;
    align-items: center;
    flex-direction: column;
    padding: 0px;
    margin: 0px;
    border: 1px solid rgba(2, 2, 6, 0.3) !important;
    cursor: ${props => props.canOpen ? 'pointer' : 'not-allowed'};

    /* Apply stripes background by default */
    background-image: url(${Stripes});
    background-size: cover; /* Ensure the stripes cover the entire card */
    background-repeat: no-repeat;
    background-position: center;

    &:hover {
        border: 1px solid ${props => props.mainColor} !important;
        background-color: transparent;
        /* Combine gradient with the stripes */
        background-image: 
            linear-gradient(
                90deg, 
                ${props => hexToRgb(props.mainColor, 0.24)} 0%, 
                ${props => hexToRgb(props.mainColor, 0.24)} 100%
            ), 
            url(${Stripes});
        background-size: cover; /* Ensure the stripes cover the entire card on hover */
        background-repeat: no-repeat;
        background-position: center;
    }
` as any;

const StyledCardNoOpen = styled(StyledCard)`
    cursor: not-allowed;
` as any;

const StyledCardLocked = styled(StyledCard)<{ mainColor: string }>`
    border: 1px solid ${props => props.mainColor} !important;

    /* Set background color and stripes */
    background-color: rgba(2, 2, 6, 0.56) !important;
    background-image: 
        linear-gradient(
            90deg, 
            ${props => hexToRgb(props.mainColor, 0.24)} 0%, 
            ${props => hexToRgb(props.mainColor, 0.24)} 100%
        ), 
        url(${Stripes});
        
    background-size: cover; /* Ensure the stripes cover the entire card */
    background-repeat: no-repeat;
    background-position: center;

    cursor: not-allowed;
` as any;


const TitleContainer = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: left;
    width: 100%;
    align-items: left;
`;

const Title = styled.h1`
    font-family: 'Meticula', sans-serif;
    color: #FFF;
    font-size: 20px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
    text-transform: uppercase;
`;

const Description = styled.p`
    font-family: 'Meticula', sans-serif;
    color: rgba(255, 255, 255, 0.72);
    font-size: 16px;
    font-style: normal;
    font-weight: 200;
    line-height: 148%; /* 23.68px */
    letter-spacing: 0.64px;
    margin-top: -4px;
    width: 638px;
`;

const CardContainer = styled.div`
    display: flex;
    flex-direction: row;
    width: 100%;
    flex-wrap: wrap;
    gap: 12px;

    height: 630px;
    overflow-y: auto;

    &::-webkit-scrollbar {
        width: 4px;
    }

    &::-webkit-scrollbar-thumb {
        background: #d6d6d6;
        border-radius: 10px;
    }

    &::-webkit-scrollbar-track {
        background: rgba(2, 2, 6, 0.56);
    }

    &::-webkit-scrollbar-thumb:hover {
        background: #787878;
    }

    &::-webkit-scrollbar-thumb:active {
        background: #787878;
    }
`;

const CardTitle = styled.h2`
    color: #FFF;
    text-align: center;
    font-family: Meticula, sans-serif;
    font-size: 16px;
    font-style: normal;
    font-weight: 600;
    line-height: normal;
    padding: 0px;
    margin: 0px;
    margin-top: 11px;
`;

const CardImage = styled.img`
    width: auto;
    height: 100%;
    max-height: 85px;
    display: block;
    margin-left: auto;
    margin-right: auto;
    margin-top: 15px;
`;

const CardAmount = styled.p`
    color: #D1D1D1;
    font-family: Meticula, sans-serif;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
`;

const EXAMPLE_ITEMS = [
    { claimed: true, canOpen: false, day: "Day 1", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238470004337541233/image.png?ex=663f6692&is=663e1512&hm=7c68068ef4a6f6e4aca75e909ad49621fdc1cc2d22e4ebe6ab45ce310dfa59c1&", item: "Item 1", amount: '$250,000' },
    { claimed: false, canOpen: true, day: "Day 2", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238239175279382649/WEAPON_KNIFE.png?ex=663f3858&is=663de6d8&hm=00602fd5078b642b34b8aca29b99cbcf9cbdf278a470781d09a2d49d80ad924b&", item: "Knife", amount: '1x' },
    { claimed: false, canOpen: true, day: "Day 3", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238234576292282508/image.png?ex=663f3410&is=663de290&hm=336cef3757adb3c55e57c447a46d834158919567703099d194f2332eb0be8c35&", item: "Pringles", amount: '1x' },
    { claimed: false, canOpen: false, day: "Day 4", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471354089607168/at_clip_extended_rifle.png?ex=663f67d4&is=663e1654&hm=ddfef9c3b3911f09a8e095c7143f159d3c1fbb7c40883fee06c4b5db10ba49d6&", item: "Ammo Clip", amount: '2x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
    { claimed: false, canOpen: false, day: "Day 5", image: "https://cdn.discordapp.com/attachments/1119540289196003410/1238471373043662869/blackusb.png?ex=663f67d9&is=663e1659&hm=299983de193e6d2b0217d230d2f640841eade284e1c8c6413430a0d07d0af166&", item: "Black USB", amount: '5x' },
];
const AnimatedCardContainer = animated(CardContainer); // Animated wrapper for the card container

const StyledCheckMark = styled(GiCheckMark)<{ mainColor: string }>`
    position: absolute;
    width: 82px;
    height: auto;
    color: ${props => props.mainColor}; /* Set the main color */
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%); /* Center the checkmark */

    /* Glowing drop shadow effect */
    filter: drop-shadow(0 0 10px ${props => props.mainColor});
`;

const StyledLock = styled(IoMdLock)<{ mainColor: string }>`
    position: absolute;
    width: 82px;
    height: auto;
    color: ${props => hexToRgb(props.mainColor, 0.6)}; /* Set the main color */
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%); /* Center the checkmark */

    /* Glowing drop shadow effect */
    filter: drop-shadow(0 0 10px ${props => props.mainColor});
`;

export default function DailyRewardsPage() {
    const [items, setItems] = useState(EXAMPLE_ITEMS);

    const { dailyRewards, setDailyRewards }:any = useDailyRewardsStore();
    const { Config }:any = getConfig();

    // setRewards
    function openCard(keyId: any, day: any) {
        const newItems = [...dailyRewards];
        const item = newItems[keyId];
        if (item.canOpen) {
            newItems[keyId] = {
                ...item,
                claimed: true,
                canOpen: false,
            };
            setDailyRewards(newItems);
            fetchNui('openDailyReward', day);
        }
    }

    function newCardOpen(keyId: any, day: string, image: string, item: string, amount: any, canOpen: boolean) {
        return (
            <StyledCard canOpen={canOpen} mainColor={Config.MainColor} w={164} h={248} p={0} m={0} onClick={() => openCard(keyId, day)}>
                <CardTitle style={{ opacity: canOpen ? '100%' : '50%' }}>{Config.Locale['day']} {day}</CardTitle>
                <CardImage src={image} />
                {!canOpen ? <StyledLock mainColor={Config.MainColor} /> : null}
                <CardTitle>{item}</CardTitle>
                <CardAmount>{amount}</CardAmount>
            </StyledCard>
        )
    }

    function newCardLocked(day: string, image: string, item: string, amount: any, canOpen: boolean) {
        return (
            <StyledCardLocked mainColor={Config.MainColorDarker} w={164} h={248} p={0} m={0}>
                <CardTitle style={{ opacity: canOpen ? '100%' : '50%' }}>
                    {Config.Locale['day']} {day}
                </CardTitle>
                <StyledCheckMark mainColor={Config.MainColor} />
                <CardImage src={image} />
                <CardTitle>{item}</CardTitle>
                <CardAmount>{amount}</CardAmount>
            </StyledCardLocked>
        )
    }

    const trail = useTrail(dailyRewards.length, {
        from: { opacity: 0, transform: 'translate3d(0,-40px,0)' },
        to: { opacity: 1, transform: 'translate3d(0,0px,0)' },
        config: { tension: 200, friction: 20 },
    });

    return (
        <>
            <TitleContainer>
                <Title>{Config.Locale['information_title']}</Title>
                <Description>
                    {Config.Locale['information_description']}
                </Description>
            </TitleContainer>

            <AnimatedCardContainer>
                {trail.map((props, index) => (
                    <animated.div style={props} key={index}>
                        {!dailyRewards[index].claimed
                            ? newCardOpen(index, dailyRewards[index].day, 'nui://ox_inventory/web/images/' + dailyRewards[index].item + '.png', dailyRewards[index].item, dailyRewards[index].amount, dailyRewards[index].canOpen)
                            : newCardLocked(dailyRewards[index].day, 'nui://ox_inventory/web/images/' + dailyRewards[index].item + '.png', dailyRewards[index].item, dailyRewards[index].amount, dailyRewards[index].canOpen)}
                    </animated.div>
                ))}
            </AnimatedCardContainer>
        </>
    )
}