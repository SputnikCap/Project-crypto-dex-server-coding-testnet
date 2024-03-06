// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RemoveLiquidityFunctions {
    // Событие для логирования операции удаления ликвидности
    event LiquidityRemoved(
        address indexed token,
        uint256 tokensWithdrawn,
        uint256 ethWithdrawn
    );

    // Функция для удаления ликвидности
    function removeLiquidity(address tokenAddress, uint256 liquidity) public {
        require(liquidity > 0, "Invalid liquidity amount");
        IERC20 token = IERC20(tokenAddress);

        // Получаем текущие резервы для токена и ETH
        uint256 ethReserve = address(this).balance;
        uint256 tokenReserve = token.balanceOf(address(this));

        // Рассчитываем, сколько токенов и ETH нужно вернуть пользователю
        uint256 ethAmount = (liquidity * ethReserve) / address(this).balance;
        uint256 tokenAmount = (liquidity * tokenReserve) / token.totalSupply();

        // Проверяем достаточность резервов
        require(ethAmount <= ethReserve, "Insufficient ETH reserve");
        require(tokenAmount <= tokenReserve, "Insufficient token reserve");

        // Переводим ETH и токены пользователю
        payable(msg.sender).transfer(ethAmount);
        token.transfer(msg.sender, tokenAmount);

        // Логируем операцию удаления ликвидности
        emit LiquidityRemoved(tokenAddress, tokenAmount, ethAmount);
    }
}
