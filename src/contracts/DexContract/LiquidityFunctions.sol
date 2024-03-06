// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityFunctions {
     // Объявляем событие LiquidityAdded
    event LiquidityAdded(
        address indexed token,
        uint256 tokensDeposited,
        uint256 ethDeposited
    );
    // Функция для добавления ликвидности
    function addLiquidity(
        address tokenAddress,
        uint256 tokenAmount
    ) public payable {
        // Проверяем, поступило ли достаточное количество токенов и ETH
        require(tokenAmount > 0, "Invalid token amount");
        require(msg.value > 0, "Invalid ETH amount");

        IERC20 token = IERC20(tokenAddress);

        // Получаем текущие резервы для токена и ETH
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 tokenReserve = token.balanceOf(address(this));

        uint256 tokenAmountToAdd;
        if (ethReserve == 0 && tokenReserve == 0) {
            // Если пул пуст, принимаем любые количества токенов и ETH
            tokenAmountToAdd = tokenAmount;
        } else {
            // Рассчитываем количество токенов в соответствии с текущим соотношением резервов
            uint256 ethAmountToAdd = (tokenAmount * ethReserve) / tokenReserve;
            require(msg.value >= ethAmountToAdd, "Not enough ETH sent");
            tokenAmountToAdd = tokenAmount;
        }

        // Переводим токены от пользователя к контракту
        token.transferFrom(msg.sender, address(this), tokenAmountToAdd);

        // Логируем операцию добавления ликвидности
        emit LiquidityAdded(tokenAddress, tokenAmountToAdd, msg.value);
    }
    // Другие функции, связанные с ликвидностью...
}
