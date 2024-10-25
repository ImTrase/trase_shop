import React, {
  Context,
  createContext,
  useContext,
  useEffect,
  useState,
} from "react";
import { useSpring, animated } from "react-spring"; // Import react-spring
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import { isEnvBrowser } from "../utils/misc";

import { useNavbarStore } from '../components/navbar/store';
import { useSelectedProductStore } from '../components/storage/store';

const VisibilityCtx = createContext<VisibilityProviderValue | null>(null);

interface VisibilityProviderValue {
  setVisible: (visible: boolean) => void;
  visible: boolean;
}

export const VisibilityProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [visible, setVisible] = useState(false);
  const { setActivePage }: any = useNavbarStore();
  const { setSelectedProduct }: any = useSelectedProductStore();

  // Add spring animation for opening and closing
  const animation = useSpring({
    opacity: visible ? 1 : 0,
    transform: visible ? "scale(1)" : "scale(0.9)",
    config: { tension: 250, friction: 20 },
  });

  useNuiEvent<boolean>("setVisible", (visible: boolean) => {
    setVisible(visible);
    setActivePage('Store'); // Reset the active page to the store
    setSelectedProduct(null); // Reset the selected product
  });

  // Handle pressing escape/backspace
  useEffect(() => {
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Backspace", "Escape"].includes(e.code)) {
        if (!isEnvBrowser()) fetchNui("hideFrame");
        else setVisible(!visible);
      }
    };

    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  }, [visible]);

  return (
    <VisibilityCtx.Provider
      value={{
        visible,
        setVisible,
      }}
    >
      {/* Outer wrapper to prevent scrollbars */}
      <div
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          width: "100vw",
          height: "100vh",
          overflow: "hidden",
          zIndex: 1000, // Ensure this is above other elements
        }}
      >
        {/* Apply spring animation for smooth transitions */}
        <animated.div
          style={{
            ...animation,
            width: "100%",
            height: "100%",
            overflow: "hidden", // Hide overflow here as well
          }}
        >
          {children}
        </animated.div>
      </div>
    </VisibilityCtx.Provider>
  );
};

export const useVisibility = () =>
  useContext<VisibilityProviderValue>(
    VisibilityCtx as Context<VisibilityProviderValue>
  );
