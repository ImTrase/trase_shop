import React, {useState} from 'react';
import { Avatar } from '@mantine/core';
import styled from "styled-components";
import { IoMdAdd } from "react-icons/io";

import Coin from '.././../assets/coin.svg';

import { useNuiEvent } from "../../hooks/useNuiEvent";
import { useCoinsStore, useTopPlayersStore } from '../storage/store';

import { getConfig } from '../storage/config';

// Function to convert hex to rgba with adjustable opacity
function hexToRgb(hex: string, opacity: number) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

const TitleContainer = styled.div`
    display: flex;
    justify-content: space-between;
    width: 100%;
    align-items: center;
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

const CoinDisplayContainer = styled.div`
    display: flex;
    gap: 9px;
`;

const AddContainer = styled.div<{ mainColor: string; darkColor: string }>`
    border-radius: 78px;
    border: 1px solid;
    border-color: rgba(255, 255, 255, 0.42);
    background: linear-gradient(100deg, rgba(177, 177, 177, 0.06) -4.77%, rgba(137, 137, 137, 0.29) 57.33%);

    width: 36px;
    height: 36px;

    display: flex;
    justify-content: center;
    align-items: center;

    cursor: pointer;
    text-select: none;

    &:hover {
        border: 1px solid ${props => hexToRgb(props.darkColor, 0.72)};
        background: ${props => hexToRgb(props.darkColor, 0.56)};
    }
`;

const CoinsContainer = styled.div<{ mainColor: string }>`
    border-radius: 100px;
    border: 1px solid;
    border-color: rgba(255, 255, 255, 0.42);
    background: linear-gradient(100deg, rgba(177, 177, 177, 0.06) -4.77%, rgba(137, 137, 137, 0.29) 57.33%);
    width: 112px;
    height: 40px;
    flex-shrink: 0;

    color: #FFF;
    font-family: 'Meticula', sans-serif;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;

    display: flex;
    justify-content: center;
    align-items: center;

    text-select: none;
`;

const PlayerListContainer = styled.div`
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-top: 5px;
    width: 100%;
    margin-bottom: 20px;
`;

const NewPlayerContainer = styled.div<{ mainColor: string, darkColor: string }>`
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    height: 48px;

    border: 1px solid;
    border-color: ${props => hexToRgb(props.mainColor, 0.72)};
    background: linear-gradient(135deg, ${props => hexToRgb(props.mainColor, 0.72)}, ${props => hexToRgb(props.darkColor, 0.72)});
    border-radius: 12px;
` as any;

const NewPlayerContainerFirst = styled(NewPlayerContainer)<{ darkColor: string }>`
    border-color: ${props => hexToRgb(props.darkColor, 0.72)};
    background: linear-gradient(135deg, ${props => hexToRgb(props.mainColor, 0.72)}, ${props => hexToRgb(props.darkColor, 0.72)});
` as any;

const NewPlayerContainerTop2 = styled(NewPlayerContainer)<{ secondaryColor: string }>`
    border-color: ${props => hexToRgb(props.secondaryColor, 0.72)};
    background: linear-gradient(135deg, ${props => hexToRgb(props.mainColor, 0.72)}, ${props => hexToRgb(props.secondaryColor, 0.72)});
` as any;

const PlayerNameContainer = styled.div`
    display: flex;
    gap: 17px;
    align-items: center;
    margin-left: 31px;
`;

const PlayerPosition = styled.h1`
    font-family: 'Meticula', sans-serif;
    color: #FFF;
    font-size: 20px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
`;

const PlayerName = styled.h1`
    font-family: 'Meticula', sans-serif;
    color: #FFF;
    font-size: 16px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
`;

const PlayerCoinContainer = styled.div`
    position: relative;

    text-align: left;
    align-items: left;

    right: 21px;

    display: flex;
    gap: 5px;
    
    color: #FFF;
    text-align: right;
    font-family: 'Meticula', sans-serif;
    font-size: 16px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
`;

const PlayerInformationContainer = styled.div`
    display: flex;
    align-items: center;
    gap: 20px;
    margin-top: 20px;
`;

const PlayerNameInfoContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: left;
    text-align: left;
    color: white;
    margin-top: 18px;
`;

const PlayerInfoText = styled.h1`
    font-family: 'Meticula', sans-serif;
    font-style: bold;
    font-weight: 400;  
    margin-top: -10px;
`;

export default function TopPlayersPage() {
    const { coins, setCoins, setIsVIP }: any = useCoinsStore();
    const { topPlayers, setTopPlayers }: any = useTopPlayersStore();
    const { Config }: any = getConfig();

    const [player, setPlayer] = useState({
        name: 'Trase',
        role: 'Developer',
        playtime: '4d 21h 16mins',
        icon: 'https://cdn.discordapp.com/attachments/833514653395976252/1238150192927342732/IMG_3532.png',
    });

    function openStore() {
        (window as any).invokeNative('openUrl', Config.StoreURL);
    }

    useNuiEvent("setPlayerData", (data: any) => {
        setPlayer(data);
        setCoins(data.coins);
        setIsVIP(data.isVIP);
    });

    useNuiEvent("setTopPlayers", (data: any) => {
        setTopPlayers(data);
    });

    function addPlayer(position: number, name: string, coins: number) {
        return (
            position === 0 ? (
                <NewPlayerContainerFirst mainColor={Config.MainColor} darkColor={Config.MainColorDarker}>
                    <PlayerNameContainer>
                        <PlayerPosition style={{ color: '#fff' }}>#{position + 1}</PlayerPosition>
                        <PlayerName>{name}</PlayerName>
                    </PlayerNameContainer>
                    <PlayerCoinContainer>
                        {coins}
                        <img src={Coin} />
                    </PlayerCoinContainer>
                </NewPlayerContainerFirst>
            ) : position === 1 || position === 2 ? (
                <NewPlayerContainerTop2 mainColor={Config.MainColor} secondaryColor={Config.SecondaryColor}>
                    <PlayerNameContainer>
                        <PlayerPosition>#{position + 1}</PlayerPosition>
                        <PlayerName>{name}</PlayerName>
                    </PlayerNameContainer>
                    <PlayerCoinContainer>
                        {coins}
                        <img src={Coin} />
                    </PlayerCoinContainer>
                </NewPlayerContainerTop2>
            ) : (
                <NewPlayerContainer mainColor={Config.MainColor}>
                    <PlayerNameContainer>
                        <PlayerPosition>#{position + 1}</PlayerPosition>
                        <PlayerName>{name}</PlayerName>
                    </PlayerNameContainer>
                    <PlayerCoinContainer>
                        {coins}
                        <img src={Coin} />
                    </PlayerCoinContainer>
                </NewPlayerContainer>
            )
        );
    }

    return (
        <>
            <TitleContainer>
                <Title>{Config.Locale['top_players_title']}</Title>
                <CoinDisplayContainer>
                    <AddContainer mainColor={Config.MainColor} darkColor={Config.MainColorDarker} onClick={openStore}>
                        <IoMdAdd width={20} height={20} color="white" />
                    </AddContainer>
                    <CoinsContainer mainColor={Config.MainColorDarker}>
                        {coins} <span style={{ color: Config.MainColor, marginLeft: 5 }}>{Config.Locale['coins_label']}</span>
                    </CoinsContainer>
                </CoinDisplayContainer>
            </TitleContainer>

            <PlayerListContainer>
                {topPlayers.map((player: any, index: any) => addPlayer(index, player.name, player.coins))}
            </PlayerListContainer>

            <PlayerInformationContainer>
                <Avatar src={player.icon} size={45} />
                <PlayerNameInfoContainer>
                    <PlayerInfoText style={{ fontSize: 16 }}>{player.name}</PlayerInfoText>
                    <PlayerInfoText style={{ fontSize: 14 }}>{player.playtime}</PlayerInfoText>
                    <PlayerInfoText style={{ fontSize: 12, color: Config.MainColor, fontWeight: 500 }}>{player.role}</PlayerInfoText>
                </PlayerNameInfoContainer>
            </PlayerInformationContainer>
        </>
    );
}
