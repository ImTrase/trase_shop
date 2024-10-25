import React, { useState } from "react";

import NavbarPage from "./navbar/page";
import TopPlayersPage from "./topplayers/page";
import StorePage from "./store/page";
import DailyRewardsPage from "./dailyRewards/page";

import { getConfig } from './storage/config';

import Coin from '../assets/coin.svg';

import { IoMdArrowRoundBack } from "react-icons/io";
import { FaDiamond } from "react-icons/fa6";


import { useNavbarStore } from './navbar/store';

import { useSelectedProductStore } from './storage/store';

import styled from "styled-components";

import { useNuiEvent } from "../hooks/useNuiEvent";
import { useDailyRewardsStore, useCoinsStore } from './storage/store';
import { fetchNui } from "../utils/fetchNui";

const LogoContainer = styled.div`
	position: absolute;
	top: 101px;
	left: 172px;

	img {
		width: 260px;
		height: auto;
	}
`;

const CloseContainer = styled.div`
	position: absolute;
	top: 133px;
	right: 153px;

	display: flex;
	gap: 12px;
`;

const CloseText = styled.p`
	font-family: 'Meticula', sans-serif;
	color: #FFF;
	font-size: 14px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
`;

const ESCButton = styled.div`
	border-radius: 100px;
	border: 1px solid;
	border-color: rgba(2, 2, 6, 0.72);
	background: rgba(2, 2, 6, 0.56);
	width: 50px;
	height: 32px;

	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 14px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;

	// center
	display: flex;
	justify-content: center;
	align-items: center;

	margin-top: 7px
`

const TopPlayersContainer = styled.div`
	position: absolute;
	top: 219px;
	left: 172px;
	width: 618px;
`

const StoreContainer = styled.div`
	position: absolute;
	top: 180px;
	left: 854px;
	width: 950px;
`

const DailyRewardsContainer = styled.div`
	position: absolute;
	top: 219px;
	left: 172px;
	width: 720px;
`

const SelectedProductContainer = styled.div`
	position: absolute;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.8);
	z-index: 100;
	backdrop-filter: blur(6px);

	display: flex;
	align-items: center;
	flex-direction: column;
`

const SelectedTitle = styled.h1`
	margin-top: 234px;
	font-family: 'Meticula', sans-serif;
	color: #FFF;
	font-size: 20px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
	text-transform: uppercase;
`;

const ItemName = styled.h2`
	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 22px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
`

const CoinContainer = styled.div`
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
`

const CoinText = styled.p`
	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 14px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
	margin: 0;
`

const ContainsText = styled.p`
	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 16px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
	margin-top: 27px;
`

const FeaturesContainer = styled.div`
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 8px;
`

const FeatureItem = styled.p`
	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 14px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
`

const NewFeatureItem = styled.p`
	display: flex;
	align-items: center;
	gap: 8px;
	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 16px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;
	margin: 0px;
	padding: 0px;
`

const NewButton = styled.button<{ mainColor: string, darkerColor: string }>`
	border-radius: 100px;
	border: 1px solid;
	border-color: rgba(2, 2, 6, 0.72);
	background: ${props => props.mainColor};
	width: 160px;
	height: 40px;

	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 14px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;

	// center
	display: flex;
	justify-content: center;
	align-items: center;

	margin-top: 57px;

	cursor: pointer;

	&:hover {
		background: ${props => props.darkerColor};
	}
`

const NewButtonDisabled = styled.button<{ mainColor: string, darkerColor: string }>`
	opacity: 0.5;
	border-radius: 100px;
	border: 1px solid;
	border-color: rgba(2, 2, 6, 0.72);
	background: ${props => props.mainColor};
	width: 160px;
	height: 40px;

	color: #FFF;
	font-family: 'Meticula', sans-serif;
	font-size: 14px;
	font-style: normal;
	font-weight: 400;
	line-height: normal;

	// center
	display: flex;
	justify-content: center;
	align-items: center;

	margin-top: 57px;

	cursor: not-allowed;
`


const GoBackContainer = styled.div<{mainColor: string}>`
	position: absolute;
	top: 160px;
	right: 200px;
	color: #FFF;

	font-family: Meticula, sans-serif;
	font-size: 14px;
	font-style: normal;
	font-weight: 600;
	line-height: normal;

	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	gap: 5px;

	border-radius: 8px;
	border: 1px solid;
	border-color: rgba(2, 2, 6, 0.72);
	background: rgba(2, 2, 6, 0.56);
	box-shadow: 0px 4px 48px 0px rgba(0, 0, 0, 0.16);

	height: 36px;

	padding: 11px 20px;

	&:hover {
		background: linear-gradient(90deg, ${props => hexToRgb(props.mainColor, 0.24)} 0%, ${props => hexToRgb(props.mainColor, 0.24)} 100%), rgba(2, 2, 6, 0.56);
		border: 1px solid ${props => props.mainColor};
	}
` as any;

function hexToRgb(hex: string, opacity: number) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

const Wrapper = styled.div<{ mainColor: string }>`
  width: 100%;
  height: 100vh;
  background: radial-gradient(
    81.12% 38.2% at 0% 1.16%, 
    ${props => hexToRgb(props.mainColor, 0.33)} 0%, 
    rgba(0, 0, 0, 0.00) 100%
  );
  overflow: hidden;
` as any;


const StyledDiamond = styled(FaDiamond)<{ mainColor: string }>`
    color: ${props => hexToRgb(props.mainColor, 0.6)};
    filter: drop-shadow(0 0 10px ${props => props.mainColor});
` as any;

export default function App() {
	const { activePage }:any = useNavbarStore();
	const { setDailyRewards }:any = useDailyRewardsStore();
	const { coins }:any = useCoinsStore();

	const { setConfig, Config }:any = getConfig();

	const { selectedProduct, setSelectedProduct }:any = useSelectedProductStore();

    useNuiEvent("setDailyRewards", (items: any) => {
        setDailyRewards(items);
    });

	useNuiEvent("setConfig", (config: any) => {
		setConfig(config);
	});

	function newFeature(text: string) {
		return (
			<NewFeatureItem>
				<StyledDiamond mainColor={Config.MainColor} size={14} />
				{text}
			</NewFeatureItem>
		)
	}

	function purchaseItem() {
		fetchNui('purchaseItem', selectedProduct);
	}

	return (
		<Wrapper mainColor={ Config.MainColor }>
			{selectedProduct ? (
				<>
					<SelectedProductContainer>
						<GoBackContainer mainColor={Config.MainColor} onClick={() => setSelectedProduct(null)}>
							<IoMdArrowRoundBack size={17} color={'#FFF'} />
							<p style={{ marginBottom: 15 }}>{Config.Locale['back']}</p>
						</GoBackContainer>
						<SelectedTitle>{Config.Locale['selected_title']}</SelectedTitle>
						<img src={selectedProduct.image} width={112} height={'auto'} style={{ marginTop: 84 }} />
						<ItemName>{selectedProduct.label}</ItemName>
						<CoinContainer>
							<img src={Coin} alt='coin' />
							<CoinText>{selectedProduct.price}</CoinText>
						</CoinContainer>
						<ContainsText>{Config.Locale['contains']}</ContainsText>
						<FeaturesContainer>
							{selectedProduct.features.map((feature: any, index: any) => (
								newFeature(feature)
							))}
						</FeaturesContainer>
						{coins >= selectedProduct.price ? (
							<NewButton mainColor={Config.MainColor} darkerColor={Config.DarkerColor} onClick={purchaseItem}>{Config.Locale['buy_now']}</NewButton>
						) : (
							<NewButtonDisabled mainColor={Config.MainColor} darkerColor={Config.DarkerColor}>{Config.Locale['cannot_buy']}</NewButtonDisabled>
						)}
					</SelectedProductContainer>
				</>
			) : null}

			<NavbarPage />

			<LogoContainer>
				{activePage === 'Store' && <img src={Config.Logo} alt='logo' />}
				{activePage === 'Daily Rewards' && <img src={Config.Logo} alt='logo' />}
			</LogoContainer>

			<CloseContainer>
				<ESCButton>{Config.Locale['escape']}</ESCButton>
				<CloseText>{Config.Locale['close']}</CloseText>
			</CloseContainer>

			{activePage === 'Store' && 
				<>
					<TopPlayersContainer>
						<TopPlayersPage />
					</TopPlayersContainer>
					<StoreContainer>
						<StorePage />
					</StoreContainer>
				</>
			}

			{activePage === 'Daily Rewards' && 
				<>
					<DailyRewardsContainer>
						<DailyRewardsPage />
					</DailyRewardsContainer>
				</>
			}
			
		</Wrapper>
	);
}