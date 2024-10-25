import React, { useState, useEffect } from "react";
import { Card, Text, Divider } from '@mantine/core';
import { useTrail, animated } from 'react-spring';
import styled from "styled-components";

import Coin from '.././../assets/coin.svg';
import { getConfig } from '../storage/config';
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { useSelectedProductStore, useCategoriesStore } from '../storage/store';
import { useNavbarStore } from '../navbar/store';

import { fetchNui } from "../../utils/fetchNui";

const STORE_CATEGORIES = [
    "Consumables",
    "Weapons",
    "Cases",
];

const Container = styled.div`
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
    gap: 12px;
`;

const Navbar = styled.nav`
    display: flex;
    justify-content: left;
    align-items: left;
    width: 100%;
    height: 60px;
    gap: 12px;
    padding-top: 45px;
`;

function hexToRgb(hex: string, opacity: number) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

const NavItem = styled.a<{ mainColor: string; darkColor: string }>`
    color: #FFF;
    text-decoration: none;
    cursor: pointer;
    font-family: 'Meticula', sans-serif;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;

    outline: none;

    width: 160px;
    height: 40px;
    flex-shrink: 0;

    border-radius: 12px;
    border: 1px solid;
    border-color: ${props => hexToRgb(props.mainColor, 0.72)};
    background: ${props => hexToRgb(props.mainColor, 0.56)};
    opacity: 0.5;

    display: flex;
    justify-content: center;
    align-items: center;
    user-select: none;

    &:hover {
        border: 1px solid ${props => hexToRgb(props.darkColor, 0.72)};
        background: ${props => hexToRgb(props.darkColor, 0.56)};
        opacity: 1;
    }
`;

const NavbarItemActive = styled.a<{ mainColor: string }>`
    color: #FFF;
    text-decoration: none;
    cursor: pointer;
    font-family: 'Meticula', sans-serif;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    opacity: 1;
    outline: none;

    width: 160px;
    height: 40px;
    flex-shrink: 0;

    border-radius: 12px;
    border: 1px solid ${props => props.mainColor};
    background: ${props => hexToRgb(props.mainColor, 0.56)};

    display: flex;
    justify-content: center;
    align-items: center;
    user-select: none;
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

const StoreContainer = styled.div`
    margin-top: 35px;
`;

const CardTitle = styled.h2`
    font-family: 'Meticula', sans-serif;
    color: #FFF;
    font-size: 16px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;

    text-overflow: ellipsis;
    white-space: nowrap;
    display: flex;
    justify-content: center;

    margin-top: -10px;
    margin-bottom: 0;
`;

const CardImage = styled.img`
    width: auto;
    height: 100%;
    max-height: 85px;
    display: block;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 0;
    padding-bottom: 0;
    margin-top: 15px;
    padding-top: 0;

    position: relative;
`;

const CardCoin = styled.div`
    display: flex;
    justify-content: center;
    align-items: center;

    color: #FFF;
    font-family: "Meticula", sans-serif;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
    gap: 8px;

    margin-top: 30px;
`;

const PurchaseTitle = styled.h2`
    font-family: 'Meticula', sans-serif;
    color: #FFF;
    font-size: 16px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;

    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    bottom: 8px;
`;

const ShopItemsContainer = styled.div`
    display: flex;
    flex-direction: row;
    gap: 12px;
    margin-top: 20px;
    flex-wrap: wrap;
    width: 100%;
    height: 550px;
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

const StyledCard = styled(Card)<{ mainColor: string, darkColor: string; }>`
    background-color: ${props => hexToRgb(props.darkColor, 0.56)} !important;
    border: 1px solid;
    border-color: rgba(2, 2, 6, 0.3) !important;

    &:hover {
        border: 1px solid ${props => props.mainColor} !important;
        background: ${props => hexToRgb(props.mainColor, 0.72)} !important;
        opacity: 0.85;
    }
` as any;

const AnimatedCard = animated(StyledCard);

export default function StorePage() {
    const { setSelectedProduct }: any = useSelectedProductStore();
    const { setCategories, categories, setActiveCategory, activeCategory }: any = useCategoriesStore();
    const [items, setItems] = useState<any[]>([]);

    const { activePage }:any = useNavbarStore();

    const { Config }: any = getConfig();

    // Filter the items based on the active category
    const filteredItems = items.filter((item) => item.category === activeCategory);

    // react-spring trail animation, recalculated when filteredItems changes
    const trail = useTrail(filteredItems.length, {
        from: { opacity: 0, transform: 'translate3d(0,-40px,0)' },
        to: { opacity: 1, transform: 'translate3d(0,0px,0)' },
        reset: true, // Ensures animation resets when category changes
        config: { tension: 200, friction: 20 },
    });

    useNuiEvent('setCategories', (categories: any) => {
        setCategories(categories);
        setActiveCategory(categories[0]);
    });

    useNuiEvent('setItems', (items: any) => {
        const updatedItems = items.map((item: any, index: number) => ({
            ...item,
            globalIndex: index + 1, // Assign a unique global index
        }));
        setItems(updatedItems);
    });

    // useEffect and fetchNui to get the items and categories
    useEffect(() => {
        fetchNui('setData');
    }, [activePage]);

    function newItem(item: string, image: string, price: number, features: string[], index: number, globalIndex: number) {
        return (
            <AnimatedCard
                mainColor={Config.MainColor}
                darkColor={Config.MainColorDarker}
                w={212}
                h={239}
                shadow="sm"
                padding="lg"
                radius="md"
                onClick={() => setSelectedProduct({ label: item, features: features, image: image, price: price, index: globalIndex })}
            >
                <CardTitle>{item}</CardTitle>
                <Card.Section component="a">
                    <CardImage src={image} />
                    <CardCoin>
                        <img src={Coin} width={20} height={20} />
                        <Text>{price}</Text>
                    </CardCoin>
                    <Divider style={{ marginTop: 14 }} />
                    <PurchaseTitle>{Config.Locale['purchase_button']}</PurchaseTitle>
                </Card.Section>
            </AnimatedCard>
        );
    }

    return (
        <Container>
            <Navbar>
                {categories.map((category: any) => (
                    category === activeCategory ? (
                        <NavbarItemActive mainColor={Config.MainColor}>{category}</NavbarItemActive>
                    ) : (
                        <NavItem mainColor={Config.MainColor} darkColor={Config.MainColorDarker} onClick={() => setActiveCategory(category)}>
                            {category}
                        </NavItem>
                    )
                ))}
            </Navbar>

            <StoreContainer>
                <Title>{Config.Locale['playtime_shop_title']}</Title>

                <ShopItemsContainer>
                    {trail.map((props, index) => (
                        <animated.div style={props} key={index}>
                            {newItem(filteredItems[index].label, Config.Images + `${filteredItems[index].item}.png`, filteredItems[index].price, filteredItems[index].features, index, filteredItems[index].globalIndex)}
                        </animated.div>
                    ))}
                </ShopItemsContainer>
            </StoreContainer>
        </Container>
    );
}
