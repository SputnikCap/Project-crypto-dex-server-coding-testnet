// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapFunctions {
    // Событие для логирования операции свапа
    event TokensSwapped(
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 tokenInAmount,
        uint256 tokenOutAmount
    );

    // Функция для свапа между токенами
    function swapTokens(
        address tokenInAddress,
        address tokenOutAddress,
        uint256 tokenInAmount,
        uint256 minTokenOutAmount
    ) public {
        require(tokenInAmount > 0, "Invalid input token amount");

        IERC20 tokenIn = IERC20(tokenInAddress);
        IERC20 tokenOut = IERC20(tokenOutAddress);

        // Локальные переменные для оптимизации доступа к хранилищу
        uint256 tokenInReserve = tokenIn.balanceOf(address(this));
        uint256 tokenOutReserve = tokenOut.balanceOf(address(this));

        // Рассчитываем количество выходных токенов
        uint256 tokenOutAmount = getTokenOutAmount(
            tokenInAmount,
            tokenInReserve,
            tokenOutReserve
        );

        require(
            tokenOutAmount >= minTokenOutAmount,
            "Insufficient output amount"
        );
        require(tokenOutAmount <= tokenOutReserve, "Insufficient liquidity");

        // Переводим токены
        tokenIn.transferFrom(msg.sender, address(this), tokenInAmount);
        tokenOut.transfer(msg.sender, tokenOutAmount);

        // Логируем операцию
        emit TokensSwapped(
            tokenInAddress,
            tokenOutAddress,
            tokenInAmount,
            tokenOutAmount
        );
    }

    // Функция для расчета количества выходных токенов
    function getTokenOutAmount(
        uint256 tokenInAmount,
        uint256 tokenInReserve,
        uint256 tokenOutReserve
    ) public pure returns (uint256) {
        // Сначала вычисляем комиссию
        uint256 tokenInAmountWithFee = tokenInAmount * 997;
        uint256 numerator = tokenInAmountWithFee * tokenOutReserve;
        uint256 denominator = (tokenInReserve * 1000) + tokenInAmountWithFee;
        return numerator / denominator;
    }
}
