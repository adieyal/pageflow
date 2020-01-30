import React from 'react';
import classNames from 'classnames';
import headerStyles from "./AppHeader.module.css";
import styles from "./LegalInfoMenu.module.css";
import InfoIcon from "../assets/images/navigation/icons/information_icon.svg";
import {LegalInfoTooltip} from "./LegalInfoTooltip";

export function LegalInfoMenu(props) {
  return (
    <div>
      <a className={classNames(headerStyles.menuIcon, styles.infoIcon)}
         data-tip data-for={'legalInfoTooltip'} >
        <InfoIcon/>
      </a>
      <LegalInfoTooltip />
    </div>
  )
}

