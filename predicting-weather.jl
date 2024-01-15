### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ b4cce075-7bbd-4d89-b27d-bbfbd370f6c5
# Import the Linear algebra module
using LinearAlgebra

# ╔═╡ 247c50ca-a235-11ed-1996-5310d664994c
md"""# Modelling and predicting weather using a Markov model

\

!!! warning "Introduction"
	In this tutorial we are going to develop a **_probabilistic model_** to predict weather for the future when today's weather is given. For this we will use a mathematical structure known as a Markov model. Also we will observe how the system behaves as time approaches infinity and find out that it reaches an equilibrium.
"""

# ╔═╡ da83799a-4344-45d6-841f-b5b1bc36ad84
md"
## How our weather system behaves

Suppose we are measuring the annual weather behavior of a city. For simplicity, we will assume that the weather condition on a single day can be either **sunny, cloudy or rainy**.

After studying the annual weather pattern rigourously we find out the following facts:

- _If today is sunny, there's a 70% chance of being sunny tomorrow, 20% chance to rain and 10% chance to be cloudy._

We can indicate these probabilities using a diagram as below. This kind of graph is called a **_Markov chain_**.

**_Note how the probabilities always add up to 1_**.
"

# ╔═╡ 4c2da205-8ceb-469d-a1e6-bd285761bc95
HTML("<img src='https://i.imgur.com/jal6pSo.jpg' width='400'>")

# ╔═╡ 67e326c2-995c-41ff-a2f9-288f0000bcf9
md"
Likewise we also find out the other probabilities and complete the diagram.

- _If today is cloudy, there's a 20% chance of being sunny tomorrow, 50% chance to rain and 30% chance to be cloudy again._

- _If today is rainy, there's a 10% chance of being sunny tomorrow, 60% chance to rain and 30% chance to be cloudy._

Remember, our probabilities have to add up to 1.
"

# ╔═╡ 18a3c160-2a63-49c4-a4a0-5fd915d29742
HTML("<img src='https://i.imgur.com/3tgwzx0.jpg' width='400'>")

# ╔═╡ 25da80f3-975f-4cf3-91d3-d71167c8a7f8
md"Our Markov chain is complete. We can also represent these data in a table like this (P denotes the probability of weather tomorrow):

|                 | P(Sunny) | P(Cloudy) | P(Rainy) |
|-----------------|----------|-----------|----------|
| Today is Sunny  | 0.7      | 0.1       | 0.2      |
| Today is Cloudy | 0.2      | 0.3       | 0.5      |
| Today is Rainy  | 0.1      | 0.3       | 0.6      |

"


# ╔═╡ 9415d8fa-99a8-475d-8999-0225f13747c1
md"## Using Linear algebra to represent data

As you look at the above table, one thing becomes obvious; we can represent this data as a matrix. And we will now see how we can use matrix-vector multiplication to obtain tomorrow's weather.

First we will create a matrix containing the above probability values. This matrix is called the transition matrix or [**_stochastic matrix_**](https://en.wikipedia.org/wiki/Stochastic_matrix).
"

# ╔═╡ 66fdbe47-9087-45e8-9569-4cd5dd1e22d5
# Take transition matrix as A
A = [0.7 0.1 0.2;
	0.2 0.3 0.5;
	0.1 0.3 0.6]

# ╔═╡ 7f68f08c-2960-4267-81af-e73f661b592b
md"
Now suppose today's weather is sunny. This would mean we know that the probability of today being sunny is 1. And the probability of other options are 0. We can denote this using a column vector.
"

# ╔═╡ 4858a963-0916-4729-b937-76661b8b9251
# Take today's weather as X_today
X_today = [1; 0; 0]

# ╔═╡ 64bdd6e9-a44d-40a4-b2ce-0e690c8fd14f
md"## Predicting the future weather
Now we will multiply X_today with A to obtain the weather for tomorrow. In general it follows the following relationship.

$X_{k+1} = A\cdot X_k$

This is a **_discrete update equation_**.

$X_{tomorrow} = A\cdot X_{today}$

Using this equation we can verify the probabilities of tomorrow's weather."

# ╔═╡ be36ce5f-4e01-44fd-8f8d-4965717cfd87
# Take the matrix-vector product resulting in a probability vector
X_tomorrow = A * X_today

# ╔═╡ f4839b66-3b76-4be1-9a69-48af2a652287
md"Indeed we get the correct values for tomorrow's weather given today is sunny. Now let's find out the weather for the day after tomorrow.

$X_{day\;after\;tomorrow} = A\cdot X_{tomorrow}$

"

# ╔═╡ 4a934f2d-f1cd-4bd7-9514-893cf47f2717
# Calculate the probabilities of weather for the day after tomorrow (X_DAT)
X_DAT = A * X_tomorrow

# ╔═╡ b98896aa-ef02-4848-9d9f-826587d7ee9a
md"It can be seen that our probability vector doesn't add up to 1. Therefore we have to normalize it."

# ╔═╡ 62bbc992-1661-4549-9854-603d796a8538
begin
	X_DAT_norm = A * X_tomorrow
	# Normalize
	X_DAT_norm = X_DAT / sum(X_DAT)
end

# ╔═╡ 02debbf2-cf49-4425-bb99-c696ebf85bee
md"Observe that it is 54% likely to be sunny.

## Simulating the system

Now let us repeat this for 50 days. By doing so we are simulating this weather system using the model we developed. For this we will start with a sunny day and see what will happen through 50 days from there onwards."

# ╔═╡ 91382625-887f-40d5-a722-38a6be46b5dd
# Set day 0 weather as sunny
X = [1; 0; 0]

# ╔═╡ 66e421c6-2468-40ec-979a-58c80d4f4991
# Loop over 50 days and print the probabilities
for i in 1:50
	# Calculate weather for next day
	X_next = A * X
	# Normalize
	X_next = X_next / sum(X_next)
	X = X_next
	# Print probabilities
	print("Day $(i)\n")
	print("Probability of sun: $(round(X[1] * 100, digits = 2)) %\n")
	print("Probability of clouds: $(round(X[2] * 100, digits = 2)) %\n")
	print("Probability of rain: $(round(X[3] * 100, digits = 2)) %\n")
	print("\n")
end

# ╔═╡ 4052e2dc-5743-4b45-ba42-063ebc13a0d0
md"Observe carefully how the probabilities ultimately converge to constant values.The system seems to have reached an equilibrium. This probability distribution is known as **_steady state distribution_**."

# ╔═╡ 33bcf852-c6c8-4156-9f47-a4ab81a8c742
md"## Explanation using eigenvectors

The equilibrium property of the above system can be related to eigenvalues and eigenvectors of the transition matrix. In theory, the equilibrium probability values we obtained before is _the eigenvector of the transition matrix corresponding to it's eigenvalue of 1._

Let's explore it in detail.

We'll take the eigen values and eigenvectors of the transition matrix A."

# ╔═╡ 43cc6dd3-4aff-4bc1-9758-94c5ce3df9bd
# Get eigenvalues of A
eigvals(A)

# ╔═╡ 109fa183-b53a-4417-a91b-6e11848fbcb8
# Get eigenvectors of A
B = eigvecs(A)

# ╔═╡ a9fdda79-9d65-4164-a6c8-88b581adf33c
md"The eigenvector corresponding to eigen value 1 is given by the third column of this matrix. But that column vector doesn't add upto 1, so we will also normalize it."

# ╔═╡ cffef3b6-8972-4eac-96bc-146872fa1e3a
# Get the normalized eigenvector
steady_state = B[:, 3] / sum(B[:, 3])

# ╔═╡ fa307868-8952-4b55-8b5e-edca81fbc040
md"And there it is! We get the same steady state distribution from our simulation. This proves that our theory aligns with the practical results."

# ╔═╡ f53586b4-6b10-4ca1-8ad0-012858041692
md"## Conclusion
In this tutorial we saw,
- What Markov models and Markov chains are
- How we can model simple Markov chains using matrices and vectors
- How to predict future outcomes and equilibrium of systems
- The math behind the equilibrium of such systems

Stay tuned for more tutorials like this!

\

>## References
>This tutorial notebook is based on a video lecture by Steven L. Brunton [Gentle Introduction to Modeling with Matrices and Vectors: A Probabilistic Weather Model](https://www.youtube.com/watch?v=K-8F_zDMDUI)
\

"

# ╔═╡ 536fac3b-3262-4ae5-be75-e7b8bca47085
md"

#### [Back to home](https://devnithw.github.io/julia-tutorials/)"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "ac1187e548c6ab173ac57d4e72da1620216bce54"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╟─247c50ca-a235-11ed-1996-5310d664994c
# ╟─da83799a-4344-45d6-841f-b5b1bc36ad84
# ╟─4c2da205-8ceb-469d-a1e6-bd285761bc95
# ╟─67e326c2-995c-41ff-a2f9-288f0000bcf9
# ╟─18a3c160-2a63-49c4-a4a0-5fd915d29742
# ╟─25da80f3-975f-4cf3-91d3-d71167c8a7f8
# ╟─9415d8fa-99a8-475d-8999-0225f13747c1
# ╠═66fdbe47-9087-45e8-9569-4cd5dd1e22d5
# ╟─7f68f08c-2960-4267-81af-e73f661b592b
# ╠═4858a963-0916-4729-b937-76661b8b9251
# ╟─64bdd6e9-a44d-40a4-b2ce-0e690c8fd14f
# ╠═be36ce5f-4e01-44fd-8f8d-4965717cfd87
# ╟─f4839b66-3b76-4be1-9a69-48af2a652287
# ╠═4a934f2d-f1cd-4bd7-9514-893cf47f2717
# ╟─b98896aa-ef02-4848-9d9f-826587d7ee9a
# ╠═62bbc992-1661-4549-9854-603d796a8538
# ╟─02debbf2-cf49-4425-bb99-c696ebf85bee
# ╠═91382625-887f-40d5-a722-38a6be46b5dd
# ╠═66e421c6-2468-40ec-979a-58c80d4f4991
# ╟─4052e2dc-5743-4b45-ba42-063ebc13a0d0
# ╟─33bcf852-c6c8-4156-9f47-a4ab81a8c742
# ╠═b4cce075-7bbd-4d89-b27d-bbfbd370f6c5
# ╠═43cc6dd3-4aff-4bc1-9758-94c5ce3df9bd
# ╠═109fa183-b53a-4417-a91b-6e11848fbcb8
# ╟─a9fdda79-9d65-4164-a6c8-88b581adf33c
# ╠═cffef3b6-8972-4eac-96bc-146872fa1e3a
# ╟─fa307868-8952-4b55-8b5e-edca81fbc040
# ╟─f53586b4-6b10-4ca1-8ad0-012858041692
# ╠═536fac3b-3262-4ae5-be75-e7b8bca47085
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
