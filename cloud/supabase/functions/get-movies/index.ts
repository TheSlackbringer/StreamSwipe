// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

console.log("Hello from Functions!")

Deno.serve(async (req) => {
try {

     const options = {
        method: 'GET',
        headers: {
          accept: 'application/json',
          Authorization: `Bearer ${Deno.env.get('TMDB_APIKEY')}`,
        },
      };

    const response = await fetch(
      'https://api.themoviedb.org/3/movie/now_playing?region=DK&page=1',
      options
    );
    const movies = await response.json();

    console.log(options.headers.Authorization)
    // Extract titles from the movies results
    //const titles = movies.results.map((movie: { title: string }) => movie.title);

    const data = {
      movies, // Return the list of titles
    };

    return new Response(JSON.stringify(data), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error fetching movies:", err);

    return new Response(
      JSON.stringify({ error: "Failed to fetch movies" }),
      { headers: { "Content-Type": "application/json" }, status: 500 }
    );
  }
});
